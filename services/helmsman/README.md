# Helmsman

Local steering layer for Claude Code, deployed remotely. Watches Claude Code sessions
through hooks and warns/blocks on house-rule violations or resemblance to past corrections.
Source + image build: `rgryta/helmsman`.

## Storage

Uses a dedicated `helmsman` logical database on `homelab-postgres` (pgvector + VectorChord).
Episodes and anti-patterns are vector-searched (`vchordrq`); tokens, proposals and all other
state live there too, so the container is stateless.

## First-time provisioning

1. Create the role, database and extensions (run once, as `postgres`):

   ```bash
   psql -h homelab-postgres -U postgres \
     -v helmsman_pw="'$HELMSMAN_DB_PASSWORD'" \
     -f provision-helmsman-db.sql
   ```

   (`provision-helmsman-db.sql` ships in the `rgryta/helmsman` repo under `deploy/`.)

2. Migrate the existing corpus (one-off, from a machine holding the sqlite corpus):

   ```bash
   HELMSMAN_PG_DSN=postgresql://helmsman:$HELMSMAN_DB_PASSWORD@homelab-postgres:5432/helmsman \
     python -m helmsman.migrate_to_pg
   ```

## Auth model

- **Machine surfaces** (`/pretooluse`, `/stop`, `/sessionstart`, `/segment-*`, `/mcp/*`) are
  gated by per-machine **bearer tokens** — hooks and the MCP shim send `Authorization: Bearer`.
  Mint one per machine:

  ```bash
  helmsmanctl token mint <machine>   # prints the secret once
  ```

  or use the **Tokens** page in the control panel. `/health` is open.

- **Control panel** (`/ui`) and its backend (`/api`) sit behind **authentik** (human SSO). Because
  the app still bearer-gates `/api`, Traefik injects a service token after authentik. Add a
  headers middleware to Traefik's file provider (`/traefik/data/`):

  ```yaml
  http:
    middlewares:
      helmsman-ui-token:
        headers:
          customRequestHeaders:
            Authorization: "Bearer <UI_TOKEN>"
  ```

  Bootstrap `<UI_TOKEN>` once on the server: `helmsmanctl token mint ui`. The `helmsman-ui`
  router (see `compose.yaml`) chains `authentik-forward-auth@file` then `helmsman-ui-token@file`,
  so a browser is authenticated by authentik and the app sees a valid token; direct
  docker-network access without a token is still rejected.

## Qwen-dependent features (degraded)

The stop **council/gate** and **stop-question** accelerator need a local Qwen chat model. The
homelab `llama-cpp` service is embeddings-only (nomic), so those features **fail open** (the gate
falls back to its keyword path) until a chat model is provisioned and `HELMSMAN_STOP_QWEN_URL` is
pointed at it. Rules, the learned-correction advisor, and anti-patterns are unaffected — they only
need embeddings (`llama.gryta.eu`).

## Client setup (per machine)

```bash
helmsmanctl token set <token>                    # writes ~/.helmsman/token (600)
export HELMSMAN_URL=https://helmsman.gryta.eu     # hooks
export HELMSMAN_DAEMON_URL=https://helmsman.gryta.eu   # MCP shim
```
