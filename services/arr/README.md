# arr

## Design notes

- `slskd` shares the VPN container's network namespace (`network_mode: container:vpn-client`), like qBittorrent, so all Soulseek traffic leaves through AirVPN. After a `vpn-client` recreate, `slskd` must be force-recreated too, same as qBittorrent.
- authentik forward-auth gates the slskd UI. slskd's own login is off (`SLSKD_NO_AUTH=true`), which is the same exposure as qBittorrent's WebUI.
- `SLSKD_SLSK_LISTEN_PORT` is the reserved AirVPN port. Keep the local and the remote port equal (see `vpn-client`).
- The `qbit.gryta.eu` entry in `extra_hosts` points at `172.20.2.3`, the same address as `vpn-client`.
- The volume declarations are grouped in this order: the *Arr configs, Tdarr, downloads, media, Soulseek.
