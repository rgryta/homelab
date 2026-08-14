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
