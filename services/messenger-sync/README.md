# messenger-sync

## Design notes

- `messenger-mcp` has no Traefik route. The server has no authentication of its own, so network isolation inside homelab-network is the whole of its access control. MCPHub reaches it at `http://messenger-mcp:8000/mcp`.
- Both services drop all capabilities and set `no-new-privileges`. Nothing needs a capability.
- `messenger-mcp` has no `env_file`. Its binary cannot link the Messenger client, so it cannot reach Messenger even if the code were wrong.
- `MESSENGER_MCP_ALLOWED_HOSTS` is rmcp's DNS-rebinding guard: the `Host` headers `/mcp` answers. MCPHub addresses the server by container name. Unset means loopback only, which returns 403 for every call while `/healthz` stays green: a container that looks healthy and answers nothing.
- `messenger-ingest` is the only process holding the Messenger login and the encrypted device, both stored in the database, and the only one with DDL rights: it applies the migrations at boot. It exposes no port, because nothing calls it. No volume: the Chromium profile it replaced (2026-11-14) is gone.
- `messenger-ingest` has no healthcheck. It sleeps about 15 minutes between passes by design, which no probe can tell apart from wedged. Use the MCP status tool instead.
