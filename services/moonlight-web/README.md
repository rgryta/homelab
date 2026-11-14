# moonlight-web

## Design notes

- There is no header-based SSO, on purpose: anything on homelab-network could send that header and drive the PC. Access is authentik forward-auth (`lldap_admin`) plus the app's own login, like code-server.
- WebRTC media advertises the NAS LAN address, which is reachable on the LAN and through WireGuard. When away from both, pick "Web Sockets" as the data transport in the player. That goes over Traefik on 443.
