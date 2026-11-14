# btx

## Design notes

- `btx-train` runs training once (a recency gate skips it when the models are fresh) and then sleeps forever. That keeps the container "Up" in Dockge instead of leaving an exited one-off.
- The `ib-gateway` healthcheck is healthy only on a fresh `ok` verdict in `/health/gateway.verdict`. A missing, unreadable or stale verdict (ingestion writer down) and any non-ok state (`logged_out`, `unknown`) are unhealthy. Before, all of these silently reported healthy and hid a logged-out gateway. A 300 s staleness limit tolerates short ingestion restarts.
