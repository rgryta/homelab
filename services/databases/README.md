# Databases

Shared database infrastructure for homelab services.

## PostgreSQL Databases

| Database | Service |
|----------|---------|
| mlflow | MLflow tracking |
| authentik | Authentik IdP |
| immich | Immich photo management |
| openfoodfacts | OpenFoodFacts API |

## Setup

Copy the Valkey configuration file:

```bash
cp valkey.conf /mnt/quick/apps/volumes/databases/valkey/valkey.conf
```
