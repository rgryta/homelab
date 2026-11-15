# whatsapp-sync

## Design notes

- Both services drop all capabilities and set `no-new-privileges`. They already run unprivileged, this stops the process gaining anything either, and nothing in here needs a capability.
- `whatsapp-ingest` and `whatsapp-mcp` set `command` to an absolute path. The image default is the MCP server.
- `whatsapp-ingest` is the only process with DDL rights. It applies the archive migrations and its own `device` schema (the account's keys, out of the MCP role's reach) at boot.
- The device was adopted from WAHA's Baileys session on first start (2026-11-13) and is stored in the database, so there is no re-pairing. The import variable and the read-only session mount were removed afterwards; the session files stay under `/mnt/quick/apps/volumes/waha/sessions`.
- Voice notes go to the whisper.cpp server on this network (`WHATSAPP_WHISPER_URL`, the `ai-cpp` stack). No model lives in this stack.
- `whatsapp-ingest` and `whatsapp-mcp` have no `env_file`, on purpose. `.env` carries both database passwords. `env_file` injects all of it regardless of what `environment:` lists, so each process would hold credentials it must never have, including write access to the archive that `whatsapp-mcp` only reads. Compose interpolates the one password each service needs from `.env` at parse time, which is why dropping `env_file` costs nothing.
- `whatsapp-mcp` has no Traefik route. It has no authentication of its own, and MCPHub reaches it in-network at `http://whatsapp-mcp:8000/mcp`. It has no WhatsApp credential and no `depends_on`, so it cannot reach WhatsApp. That is enforced by the binary's dependency graph, not by trust.
- `whatsapp-mcp` connects with a read-only database role. It cannot create or alter anything, by design.
- `WHATSAPP_SESSION` is deliberately unset: with one session, the server infers it.
- `WHATSAPP_MCP_ALLOWED_HOSTS` is rmcp's DNS-rebinding guard: the `Host` headers `/mcp` answers. MCPHub addresses the server by container name. Unset means loopback only, which returns 403 for every call while `/healthz` stays green.
