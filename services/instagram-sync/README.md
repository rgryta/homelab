# instagram-sync

## Design notes

- `instagram-mcp` has no Traefik route. The server has no authentication of its own, so network isolation inside homelab-network is the whole of its access control. MCPHub reaches it at `http://instagram-mcp:8000/mcp`.
- Both services drop all capabilities and set `no-new-privileges`. Nothing needs a capability.
- `instagram-mcp` has no `env_file`. Its binary cannot link the Instagram client, so it cannot reach Instagram even if the code were wrong, and its database role cannot read `ingest_session`.
- `instagram-mcp` connects with a read-only database role. It cannot create or alter anything, by design.
- `INSTAGRAM_MCP_ALLOWED_HOSTS` is rmcp's DNS-rebinding guard: the `Host` headers `/mcp` answers. MCPHub addresses the server by container name. Unset means loopback only, which returns 403 for every call while `/healthz` stays green: a container that looks healthy and answers nothing.
- `instagram-ingest` is the only process holding the Instagram session (a cookie jar in the `ingest_session` table) and the only one with DDL rights: it applies the migrations at boot. It exposes no port, because nothing calls it. No volume: the Chromium profile it replaced (2026-11-16) is gone.
- `instagram-ingest` has no healthcheck. It sleeps about 15 minutes between full passes by design, which no probe can tell apart from wedged. Use the MCP status tool instead.
- `instagram-ingest` takes `INSTAGRAM_ACCOUNT` by name rather than the whole `.env`, so it does not receive the MCP role's password.
- A fresh session is seeded once from a browser cookie export: mount it read-only and set `INSTAGRAM_COOKIES_FROM` for one start, then remove both. The database copy wins from then on.
- Both services follow `ghcr.io/rgryta/instagram-sync` release tags through wud's `dockercompose.instagram` trigger, as messenger-sync does.
