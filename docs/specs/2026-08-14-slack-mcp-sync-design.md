# Slack MCP + persistence — design

Date: 2026-08-14
Status: approved, not implemented

## Problem

Slack should be queryable from claude.ai through the existing MCPHub instance
(`mcp.gryta.eu`, container `mcphub` at 172.20.0.81). Two constraints shape the design:

1. **No Slack app can be registered.** No bot token, no OAuth app, no Socket Mode,
   therefore no real-time push. The only available credential is the browser/desktop
   session of an already-authenticated Slack client on the mac `mac-complexio`
   (`10.8.0.4`, ssh alias `mac-complexio`): an `xoxc-*` token plus the `d` cookie
   (`xoxd-*`). These speak Slack's API as the user, with exactly the user's own
   visibility — nothing more.
2. **Queries must not re-hit Slack.** Message history is persisted in the existing
   `homelab-postgres` (172.20.0.30) so repeated questions are answered locally.

Scope of interest is deliberately narrow: **all DMs and group DMs**, **`#stevie`**,
**`#stevie-dev`**, and **threads the user was @-mentioned in**, wherever they occur.

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Capability | **Read-only** | Nothing can post as the user. Smallest blast radius. |
| Token refresh | **Manual** | Re-extract from `mac-complexio` when Slack starts 401ing. No launchd job, no ssh-from-NAS orchestration. |
| Corpus | **Full backfill + poll** | Deep history locally; poll keeps it current. |
| Mention discovery | **Crawl all member channels, filter** | No dependency on `search.messages` availability. |
| Retention | **In-scope only** | Non-matching messages are read and discarded, never stored. |
| Build shape | **Own ingester + own MCP server** | Credentials isolated from the tool-serving process. |
| Content | **Messages + reactions** | No files, no attachments, no blocks. |
| Accounts | **Multi-account from day one** | Several Slack accounts feed one MCP surface. |
| Workspace | **First-class, separate from account** | An account is a credential; a workspace is a team. Slack Connect means one account sees channels owned by other teams, so workspace must be filterable independently. |
| Aliases | **User-settable, stored locally** | `ted` is a better search handle than `U01AB2CD3`. |

### Rejected alternatives

- **`korotovsky/slack-mcp-server` as-is, plus a search server beside it.** Fast to
  stand up, but yields two overlapping toolsets in MCPHub (the model picks wrong),
  keeps live credentials in the tool-serving process, and its cache is CSV files —
  the required persistence stays bolted on the side.
- **Forking `korotovsky/slack-mcp-server` to add a Postgres write-through cache.**
  Single toolset, but means owning a fork of an active Go upstream indefinitely,
  against history logic built around its own cache assumptions.
- **Egress proxied through the mac over an ssh SOCKS tunnel**, so Slack API calls
  originate from the same IP as the real client. Lowest chance of session
  invalidation, but rejected as premature plumbing; revisit only if sessions prove
  to die often.
- **`search.messages` for mention discovery.** Cheaper and server-side, but depends
  on the search API being usable by a session token on this workspace's plan.

## Architecture

```
mac-complexio ──(manual, one-off)──> .env: SLACK_XOXC_<ACCOUNT>, SLACK_XOXD_<ACCOUNT>
                                       │
homelab-network                        ▼
  slack-ingest-<account> (172.20.0.83+) ──HTTPS──> slack.com API
        │ writes (role slack_ingest)
        ▼
  homelab-postgres:5432  db=slack
        ▲ reads (role slack_mcp, SELECT only)
        │
  slack-mcp (172.20.0.82) ──streamable HTTP :8000/mcp──> mcphub ──> claude.ai
```

One image, two entrypoints: `slack-sync ingest` and `slack-sync mcp`.
**One ingester container per Slack account; exactly one MCP container.**

The MCP container holds no Slack credentials and has no code path that calls
Slack. Read-only *toward Slack* is therefore a property of the deployment, not a
policy to trust. Its one write privilege is the local alias tables, granted at the
role level — it cannot modify a message, a conversation, or any sync state. A dead
token degrades the system to "data is stale" — never to "tools are broken".

### Ingester

Two loops sharing one global rate limiter per process (conservative token bucket,
honours `Retry-After` on 429; limits are per-token, so per-process is the correct
granularity).

- **Boot**: `auth.test` → resolves `team_id` and `my_user_id`; `team.info` fills the
  `workspace` row; `emoji.list` syncs custom emoji. Upserts the `account` row.
  `my_user_id` is required for the mention filter.
- **Poll loop (priority)**: every `SLACK_POLL_INTERVAL` (default 5 min),
  `conversations.list` to pick up membership drift, then forward-fetch each
  conversation from its stored cursor.
- **Backfill loop (background, resumable)**: pages backwards through one
  conversation at a time until exhausted. Never blocks the poll loop, so fresh data
  cannot starve behind a multi-hour crawl. A restart loses at most one page.

The first full crawl of every member channel is the expensive part — hours, possibly
longer on a large workspace, and the most likely place to meet rate limits. It is
throttled, resumable, and strictly background for exactly that reason.

### Scan-and-discard filter

The single point that decides what is stored. A message is persisted only if:

1. its conversation is in scope — any DM (`im`) or group DM (`mpim`), or a channel
   named in `SLACK_SCOPE_CHANNELS`; **or**
2. it contains `<@{my_user_id}>` — which additionally registers
   `(account, conversation, thread_ts)` in `mention_thread` and triggers a full
   `conversations.replies` pull of that thread; **or**
3. it belongs to an already-registered `mention_thread`, so later replies to a
   thread the user was pinged on keep flowing in.

Everything else is read, matched, and dropped. If a message is a thread parent
(`thread_ts == ts`) that becomes in-scope by rule 2, the whole thread is fetched,
not just the mentioning message.

### Storage

Database `slack` on `homelab-postgres`. Two roles: `slack_ingest` (read/write on
everything), `slack_mcp` (`SELECT` on everything, plus `INSERT`/`UPDATE`/`DELETE` on
`user_alias` and nothing else).

Slack IDs are unique only within a workspace, so `account_id` is the leading column
of every key.

| Table | Key | Columns |
|---|---|---|
| `workspace` | `team_id` | `name`, `domain`, `is_external`, `first_seen` |
| `account` | `id` (short label, e.g. `work`) | `team_id` → `workspace`, `my_user_id`, `enabled`, `last_auth_error`, `last_auth_error_at` |
| `conversation` | `(account_id, id)` | `team_id` (owning workspace), `shared_team_ids text[]`, `type` (`im`/`mpim`/`channel`/`group`), `name`, `is_member`, `in_scope`, `scope_reason`, `backfill_cursor`, `backfill_done`, `poll_cursor`, `last_polled_at`, `reactions_fresh_until` |
| `message` | `(account_id, conversation_id, ts)` | `thread_ts`, `user_id`, `text`, `subtype`, `edited_at`, `deleted_at`, `raw jsonb` |
| `reaction` | `(account_id, conversation_id, message_ts, name)` | `user_ids text[]`, `count`, `observed_at` |
| `emoji` | `(team_id, name)` | `url`, `alias_for`, `updated_at` |
| `mention_thread` | `(account_id, conversation_id, thread_ts)` | `first_seen`, `mention_ts` |
| `workspace_user` | `(account_id, user_id)` | `team_id`, `name`, `real_name`, `is_bot`, `updated_at` |
| `user_alias` | `alias` | `note`, `created_at`, `updated_at` |
| `user_alias_member` | `(account_id, user_id)` | `alias` → `user_alias` |
| `sync_state` | `(account_id, loop)` | `current_conversation_id`, `last_run_at`, `last_error`, `last_error_at` |

Per-conversation paging cursors live on `conversation` (`poll_cursor`,
`backfill_cursor`). `sync_state` holds only loop-level state — which conversation the
backfill loop is currently working through, and each loop's last run and last error.
`conversation.scope_reason` is one of `dm`, `group_dm`, `named_channel`,
`mention_thread`.

#### Workspace vs account

An **account** is a credential (one `xoxc`/`xoxd` pair, one ingester container). A
**workspace** is a Slack team. They are not the same axis: two accounts can live in
one workspace, and — through Slack Connect — one account sees channels *owned by*
other teams. So `conversation.team_id` records the owning workspace and
`shared_team_ids` the teams a shared channel spans, both independent of which account
ingested the row. `workspace.is_external` marks teams known only as the far side of a
Connect channel. Filtering by workspace is therefore a real filter, not a synonym for
filtering by account.

The ingester populates `workspace` from `auth.test` and `team.info` on boot, and adds
external teams lazily as shared channels are encountered.

#### Reactions and emoji

`reaction` rows are derived from the `reactions` array Slack returns on each message
fetch — they are a snapshot at fetch time, not an event stream. Without an app there
is no reaction event to subscribe to, so **a reaction added to a message we already
fetched is invisible until that message is fetched again.**

Mitigation: on each poll, in-scope conversations re-fetch a rolling recency window
(`SLACK_REACTION_WINDOW`, default 7 days) so reactions on recent messages stay
current; `conversation.reactions_fresh_until` records how far back that guarantee
extends. Older messages keep whatever reactions they had when last read. Reaction
counts on old history are therefore a floor, never authoritative — tools surface
`reactions_fresh_until` so the distinction is visible rather than assumed.

Custom emoji are synced from `emoji.list` per workspace into `emoji` (with
`alias_for` resolved for Slack's `alias:` entries), so `:shipit:` in message text can
be named and linked rather than left an opaque token. Standard Unicode emoji need no
table; they are already literal in `text`.

#### Aliases

An alias is a local, human-chosen handle for a person — `ted`, `stevie-pm` — and it
maps to **many Slack identities**: `user_alias` holds the name, `user_alias_member`
attaches `(account_id, user_id)` pairs to it. That structure is the point. The same
colleague in two workspaces is two different Slack user IDs; one alias covers both,
so `author: ted` in a search means "Ted anywhere" without you knowing either ID.

Each Slack identity belongs to at most one alias. Aliases are stored only here and
never written back to Slack.

Rendering precedence in tool output: alias → `real_name` → `name` → raw ID.

`raw jsonb` is stored with `files` and `blocks` **stripped before insert** — it
exists as a reprocess-locally escape hatch for schema mistakes, not as an archive
of attachments.

Full-text search: a generated `tsvector` column on `message` with a GIN index, using
the **`simple`** text search configuration rather than `english`. The corpus is
mixed-language; stemming under the wrong dictionary silently loses hits.

Deletions and edits observed during polling update `deleted_at` / `edited_at` rather
than removing rows.

### MCP tool surface

Postgres-backed. Read-only toward Slack throughout; the only writes any tool performs
are to `user_alias` / `user_alias_member`. Every read tool takes optional `account`
**and** `workspace` filters; omitted means all, and every result is labelled with both
so two teams are never conflated.

| Tool | Purpose |
|---|---|
| `slack_list_conversations` | In-scope conversations: account, workspace, type, name, message count, last activity. The entry point — IDs come from here. |
| `slack_history` | Messages in a conversation by time range / limit, cursor-paged, with reactions. |
| `slack_thread` | Full thread by `(account, conversation, thread_ts)`. |
| `slack_search` | Full-text search over the persisted corpus; filters for account, workspace, conversation, author (alias or ID), date range, and `has_reaction`. Returns snippets plus `thread_ts` for drill-in. |
| `slack_my_mentions` | The `mention_thread` set, newest first, with the mentioning message. |
| `slack_unread_since` | Everything in scope after a timestamp — the "catch me up" call. |
| `slack_list_workspaces` | Known teams, whether external, and how many in-scope conversations each holds. |
| `slack_set_alias` | Attach an alias to one or more Slack identities, or move/rename one. Writes `user_alias*` only. |
| `slack_list_aliases` | Aliases with their member identities, for checking what `ted` currently resolves to. |
| `slack_sync_status` | Per-account, per-conversation freshness, backfill progress, `reactions_fresh_until`, and the last auth error. This is how a dead token is discovered. |

`slack_search` defaults to **all accounts and all workspaces**; labels disambiguate.

Output is compact rendered text, not raw JSON: user references resolved by the
alias → `real_name` → `name` → ID precedence, custom emoji named from `emoji`,
timestamps as local time. Reactions render inline as `:name: ×3`. Raw Slack payloads
are large enough to consume the context window for no benefit.

## Deployment

- **New repo `slack-sync`** — Python 3.13, `.venv`, `slack_sdk` + `asyncpg` +
  FastMCP. One image, two entrypoints.
- **Stack** `/homelab_stack/slack/compose.yaml`, mirrored to `services/slack/` in the
  homelab repo, following the mcphub/waha pattern: static IPs on `homelab-network`,
  `.env` for credentials, `deploy.resources.limits`, healthchecks, `wud.watch`.
- **IPs**: `slack-mcp` 172.20.0.82; `slack-ingest-<account>` from 172.20.0.83
  upward. Recorded in `docs/networks.md`.
- **No Traefik route.** The MCP container is reachable only in-network, by mcphub.
- **MCPHub registration**: a server entry pointing at `http://172.20.0.82:8000/mcp`.
- **DB provisioning**: `slack` database and the two roles created in
  `homelab-postgres`.

Adding a second Slack account later is a compose block plus two secrets — no schema
change, no MCP change.

### Token lifecycle

The `xoxc` token rotates roughly on session refresh; the `xoxd` cookie lasts months.
On a 401 the ingester stops calling Slack, records the failure in
`account.last_auth_error`, and keeps the process alive. Tools continue serving stale
data. Recovery: `ssh mac-complexio`, re-extract token and cookie, update `.env`,
restart that one ingester container.

## Testing

Schema and filter logic under pytest against a throwaway Postgres; the Slack client
mocked from recorded fixtures.

The scan-and-discard filter is the part that earns real tests: a bug there means
either storing messages that were explicitly out of scope, or silently missing
mentions. Cases to cover — DM, group DM, scoped channel, unscoped channel with a
mention, unscoped channel without one, a reply arriving on an already-registered
mention thread, a mention inside a thread whose parent has no mention, and a
message mentioning a *different* user.

Two further areas need tests of their own: **reaction reconciliation** — a re-fetch
must add new reactions, drop removed ones, and update counts without duplicating rows
or resurrecting reactions on messages outside the window — and **alias resolution**,
where one alias spans two accounts, an identity is moved between aliases, and an
alias is deleted while messages referencing it remain.

## Out of scope for v1

Files and attachments, real-time push (impossible without an app), any write path
toward Slack, Traefik exposure, automated token refresh, egress via the mac.

## Risks

- **First crawl cost.** Hours or longer; mitigated by throttling, resumability, and
  keeping backfill strictly behind the poll loop.
- **Session tokens are outside Slack's blessed path.** Acceptable for personal use of
  one's own account; the tokens grant nothing the user cannot already see.
- **Manual refresh means silent staleness** between the token dying and being
  noticed. `slack_sync_status` is the only detector; check it when results look old.
- **Reaction counts on old messages are a floor, not a truth.** No app means no
  reaction events; only the rolling re-fetch window keeps them current. Anything
  older than `reactions_fresh_until` reflects the last time that message was read.
- **The re-fetch window costs API calls on every poll**, proportional to in-scope
  message volume rather than to new messages. If it proves expensive, shrink
  `SLACK_REACTION_WINDOW` before touching the poll interval.
