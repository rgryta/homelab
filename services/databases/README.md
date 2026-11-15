# Databases

Shared database infrastructure for homelab services.

## PostgreSQL Databases

| Database | Service |
|----------|---------|
| mlflow | MLflow tracking |
| authentik | Authentik IdP |
| immich | Immich photo management |
| openfoodfacts | OpenFoodFacts API |
| slack | Slack ingest + MCP (roles: slack_ingest owns it, slack_mcp reads it) |

## Setup

Copy the Valkey configuration file:

```bash
cp valkey.conf /mnt/quick/apps/volumes/databases/valkey/valkey.conf
```

## Design notes

- `PGADMIN_LISTEN_PORT: "80"` on `pgadmin`: with `cap_drop: ALL` pgAdmin detects a "restricted security context" and moves from port 80 to 8080. The healthcheck and the Traefik router use port 80, so the port is set explicitly.
