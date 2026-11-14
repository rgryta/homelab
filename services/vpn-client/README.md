# vpn-client

## Design notes

- `FIREWALL_INPUT_PORTS=8888,5030`: the qBittorrent (8888) and slskd (5030) WebUIs share this network namespace, so they must be reachable from Traefik.
- `FIREWALL_VPN_INPUT_PORTS` lists the reserved AirVPN ports. Inbound peers (BitTorrent, Soulseek) arrive through the tunnel on those ports.
- `DOT=off` keeps pihole as the resolver instead of gluetun's built-in DNS over TLS.
