# mcphub

## Design notes

- The `mcp.gryta.eu` router deliberately has no authentik forward-auth. MCPHub owns its own auth (admin login plus Better Auth OIDC federated to authentik), and it must serve `/.well-known/*`, `/oauth/*` and `/mcp` unauthenticated so claude.ai can run the OAuth handshake against it.
- Setting `DB_URL` switches MCPHub from file mode to database mode.
- The Better Auth variables give SSO login federated to authentik. They govern who may log in to MCPHub. They are not the OAuth that claude.ai speaks: MCPHub is its own authorization server for that, which keeps authentik's path-bearing issuer out of the connector handshake. The callback is `/api/auth/better/oauth2/callback/oidc`.
- `BETTER_AUTH_SECRET` is required, because the better-auth library refuses to run on its default secret.
- `BASE_PATH` is deliberately not set. MCPHub registers the discovery route at the absolute path `/.well-known/oauth-protected-resource`, but builds the advertised URL with `BASE_PATH` prepended. A non-empty value makes the advertised URL return 404, which silently breaks claude.ai OAuth discovery.
