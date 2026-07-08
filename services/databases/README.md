# Databases

Shared database infrastructure for homelab services.

## PostgreSQL Databases

| Database | Service |
|----------|---------|
| mlflow | MLflow tracking |
| authentik | Authentik IdP |
| immich | Immich photo management |
| openfoodfacts | OpenFoodFacts API |
| bemol | bemol karaoke service |

## Valkey logical databases

Valkey is a single shared instance (`maxmemory 512mb`, `allkeys-lru`). Each
broker/cache consumer gets a distinct logical DB index to avoid key collisions.

| Index | Service |
|-------|---------|
| 1 | BTX |
| 2 | bemol (Celery broker) |

> bemol uses its index as a Celery **broker** (queue keys have no TTL). Under
> `allkeys-lru` a memory-pressure eviction can silently drop queued tasks; switch
> the policy to `volatile-lru` if broker durability becomes a concern.

## Setup

Copy the Valkey configuration file:

```bash
cp valkey.conf /mnt/quick/apps/volumes/databases/valkey/valkey.conf
```
