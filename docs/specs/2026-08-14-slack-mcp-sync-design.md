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
| Content | **Messages only** | No files, no attachments, no blocks. |
| Accounts | **Multi-account from day one** | Several Slack accounts feed one MCP surface. |

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
Slack. Read-only is therefore a property of the deployment, not a policy to trust.
A dead token degrades the system to "data is stale" — never to "tools are broken".

### Ingester

Two loops sharing one global rate limiter per process (conservative token bucket,
honours `Retry-After` on 429; limits are per-token, so per-process is the correct
granularity).

- **Boot**: `auth.test` → resolves `team_id`, `team_name`, `my_user_id`; upserts the
  `account` row. `my_user_id` is required for the mention filter.
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

Database `slack` on `homelab-postgres`. Two roles: `slack_ingest` (read/write),
`slack_mcp` (`SELECT` only, granted to the MCP container).

Slack IDs are unique only within a workspace, so `account_id` is the leading column
of every key.

| Table | Key | Columns |
|---|---|---|
| `account` | `id` (short label, e.g. `work`) | `team_id`, `team_name`, `my_user_id`, `enabled`, `last_auth_error`, `last_auth_error_at` |
| `conversation` | `(account_id, id)` | `type` (`im`/`mpim`/`channel`/`group`), `name`, `is_member`, `in_scope`, `scope_reason`, `backfill_cursor`, `backfill_done`, `poll_cursor`, `last_polled_at` |
| `message` | `(account_id, conversation_id, ts)` | `thread_ts`, `user_id`, `text`, `subtype`, `edited_at`, `deleted_at`, `raw jsonb` |
| `mention_thread` | `(account_id, conversation_id, thread_ts)` | `first_seen`, `mention_ts` |
| `workspace_user` | `(account_id, user_id)` | `name`, `real_name`, `is_bot`, `updated_at` |
| `sync_state` | `(account_id, loop)` | `current_conversation_id`, `last_run_at`, `last_error`, `last_error_at` |

Per-conversation paging cursors live on `conversation` (`poll_cursor`,
`backfill_cursor`). `sync_state` holds only loop-level state — which conversation the
backfill loop is currently working through, and each loop's last run and last error.
`conversation.scope_reason` is one of `dm`, `group_dm`, `named_channel`,
`mention_thread`.

`raw jsonb` is stored with `files` and `blocks` **stripped before insert** — it
exists as a reprocess-locally escape hatch for schema mistakes, not as an archive
of attachments.

Full-text search: a generated `tsvector` column on `message` with a GIN index, using
the **`simple`** text search configuration rather than `english`. The corpus is
mixed-language; stemming under the wrong dictionary silently loses hits.

Deletions and edits observed during polling update `deleted_at` / `edited_at` rather
than removing rows.

### MCP tool surface

Read-only, Postgres-backed. Every tool takes an optional `account` filter; omitted
means all accounts, and every result is labelled with its account so two workspaces
are never conflated.

| Tool | Purpose |
|---|---|
| `slack_list_conversations` | In-scope conversations: account, type, name, message count, last activity. The entry point — IDs come from here. |
| `slack_history` | Messages in a conversation by time range / limit, cursor-paged. |
| `slack_thread` | Full thread by `(account, conversation, thread_ts)`. |
| `slack_search` | Full-text search over the persisted corpus; filters for account, conversation, author, date range. Returns snippets plus `thread_ts` for drill-in. |
| `slack_my_mentions` | The `mention_thread` set, newest first, with the mentioning message. |
| `slack_unread_since` | Everything in scope after a timestamp — the "catch me up" call. |
| `slack_sync_status` | Per-account, per-conversation freshness and backfill progress, plus the last auth error. This is how a dead token is discovered. |

`slack_search` defaults to **all accounts**; labels disambiguate.

Output is compact rendered text, not raw JSON: `<@U…>` resolved to display names via
`workspace_user`, timestamps as local time. Raw Slack payloads are large enough to
consume the context window for no benefit.

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

## Out of scope for v1

Files and attachments, reactions and emoji, real-time push (impossible without an
app), any write path, Traefik exposure, automated token refresh, egress via the mac.

## Risks

- **First crawl cost.** Hours or longer; mitigated by throttling, resumability, and
  keeping backfill strictly behind the poll loop.
- **Session tokens are outside Slack's blessed path.** Acceptable for personal use of
  one's own account; the tokens grant nothing the user cannot already see.
- **Manual refresh means silent staleness** between the token dying and being
  noticed. `slack_sync_status` is the only detector; check it when results look old.
