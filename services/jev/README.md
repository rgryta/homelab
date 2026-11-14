# jev

## Design notes

Compose file is not in this repository yet. These notes come from the comments in the deployed `jev` stack.

- `jev-mcp` is reached only through MCPHub on the private bridge. Nothing is published to Traefik.
- The API key lives in `.env` as `JEV_API_KEY`. The binary reads `TYPESAFE_API_KEY`, so compose maps one to the other.
- `JEV_MCP_ALLOWED_HOSTS` is rmcp's DNS-rebinding guard: the `Host` headers `/mcp` answers. MCPHub addresses the server by container name. Unset means loopback only, which returns 403 for every call while `/healthz` stays green.
