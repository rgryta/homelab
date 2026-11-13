# Helmsman

Local steering layer for Claude Code, deployed remotely. Watches Claude Code sessions
through hooks and warns/blocks on house-rule violations or resemblance to past corrections.
Source + image build: `rgryta/helmsman-server` (Rust), mirrored to `172.20.0.52:5000/helmsman-server:<version>`.

## Storage

Uses a dedicated `helmsman` logical database on `homelab-postgres` (pgvector + VectorChord).
Episodes and anti-patterns are vector-searched (`vchordrq`); tokens, proposals and all other
state live there too, so the container is stateless.

## First-time provisioning

Create the role, database and extensions once (as `postgres`); the server applies its own
migrations on start:

```bash
psql -h homelab-postgres -U postgres \
  -v helmsman_pw="'$HELMSMAN_DB_PASSWORD'" \
  -f provision-helmsman-db.sql
```

Rules, groups and hints are inline compose `configs:` mounted read-only at `/knowledge/` (mode 0444), so no host files or volumes are involved. They originate in `rgryta/helmsman-private` under `knowledge/`; `$` is escaped as `$$` in compose.

## Auth model

- **Machine surfaces** (`/pretooluse`, `/stop`, `/sessionstart`, `/segment-*`, `/mcp/*`) are
  gated by per-machine **bearer tokens** — hooks and the MCP shim send `Authorization: Bearer`.
  Mint one per machine:

  ```bash
  helmsman-server token mint <machine>   # prints the secret once
  ```

  `/health` is open.

- **`/api`** is bearer-gated too. The Rust server serves no `/ui` dashboard, so the Authentik
  `helmsman-ui` router is gone.

## LLM

`HELMSMAN_LLM_URL` and `HELMSMAN_LLM_MODEL` (in `.env`) point at the chat model backing the stop
council/gate; embeddings use `HELMSMAN_EMBED_URL` (default `https://llama.gryta.eu`).

## Rollback

The previous Python image was `172.20.0.52:5000/helmsman@sha256:67ad1a0e3b0c7196e316dfce3e48aea7876ebd22fe75d76f2df43a88bdeda7bf`.
Same database, no schema change: restore the old compose with that image and recreate.

## Client setup (per machine)

```bash
helmsmanctl token set <token>                    # writes ~/.helmsman/token (600)
export HELMSMAN_URL=https://helmsman.gryta.eu     # hooks
export HELMSMAN_DAEMON_URL=https://helmsman.gryta.eu   # MCP shim
```
