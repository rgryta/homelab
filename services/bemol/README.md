# bemol

## Design notes

- The database and the broker live in the shared `databases` stack (`homelab-postgres`, `homelab-valkey`). Bemol reaches them over homelab-network through `BEMOL_DATABASE_URL` and `BEMOL_REDIS_URL` in `.env`.
