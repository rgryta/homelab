# Homelab

TrueNAS Dockge-based homelab with containerized services.

## Services

| Service | Description |
|---------|-------------|
| [Traefik](services/traefik/) | Reverse proxy with Let's Encrypt SSL |
| [Authentik](services/authentik/) | OAuth2/OIDC authentication provider |
| [LLDAP](services/lldap/) | LDAP directory service |
| [Filebrowser](services/filebrowser/) | Filebrowser Quantum, web-based file manager with its own OIDC |
| [Mailserver](services/mailserver/) | Roundcube + docker-mailserver |
| [Jellyfin](services/jellyfin/) | Media server with Jellyseerr |
| [Arr](services/arr/) | Media automation (Sonarr, Radarr, Prowlarr, Lidarr, Bazarr, Cleanuparr, Tdarr) |
| [qBittorrent](services/qbittorrent/) | Torrent client (via VPN) |
| [VPN Client](services/vpn-client/) | Gluetun/AirVPN container for tunneled services |
| [WireGuard](services/wireguard/) | VPN server for external client access (wg-easy, OIDC) |
| [Immich](services/immich/) | Photo and video management |
| [Syncthing](services/syncthing/) | File sync from phone, wireguard-only GUI |
| [VS Code](services/vscode/) | Web-based code editor |
| [Firefox](services/firefox/) | Standalone browser behind Authentik |
| [macOS](services/macos/) | macOS virtualization (not deployed) |
| [Android](services/android/) | Android emulator (not deployed) |
| [OpenFoodFacts](services/openfoodfacts/) | Food product database API (not deployed) |
| [Prometheus](services/prometheus/) | Monitoring stack (Prometheus, Grafana, cAdvisor) |
| [Databases](services/databases/) | Unified database infrastructure (PostgreSQL, Valkey, QuestDB, Memgraph, MongoDB, Redpanda, MLflow, Garage) |
| [PiHole](services/pihole/) | DNS ad-blocking with Unbound |
| [What's Up Docker](services/wud/) | Container update checker |
| [Autoheal](services/autoheal/) | Restarts containers failing their healthcheck |
| [Llama.cpp](services/llama-cpp/) | Local LLM inference |
| [Helmsman](services/helmsman/) | Claude Code steering daemon (Postgres/VectorChord) |
| [Bemol](services/bemol/) | Lyrics alignment and karaoke pipeline |
| [BTX](services/btx/) | IBKR gateway and training stack |
| [MCPHub](services/mcphub/) | MCP server aggregator |
| [Slack](services/slack/) | Slack ingester + read-only MCP server backed by PostgreSQL |
| [WAHA](services/waha/) | WhatsApp HTTP gateway + whatsapp-sync ingester and MCP |
| [Instagram](services/instagram/) | Instagram ingester + MCP server |
| [Messenger](services/messenger-sync/) | Messenger harvester + MCP server |
| [Act Parking](services/act-parking/) | Parking automation |
| [PagerDuty Auto Ack](services/pagerduty-auto-ack/) | Auto-acknowledges assigned PagerDuty incidents |
| [Preview](services/preview/) | Airborn Scout preview/discovery service (not deployed) |
| [WellMate](services/wellmateio/) | Wellness tracking (not deployed) |
| [GitHub Runner](services/github-runner-wellmate/) | Self-hosted GitHub Actions runner (not deployed) |
| [Whoami](services/whoami/) | Debug service |

## Documentation

- [Networks](docs/networks.md) - IP addresses and network configuration
- [Mounts](docs/mounts.md) - Storage paths and volume strategy
- [Labels](docs/labels.md) - Traefik routing and middleware patterns

## Setup

### Dockge Resources

- CPU: 1
- Memory: 512MB

### Volume Preparation

Each service has a `volume.sh` script to create required directories. Run from within Dockge:

```bash
./services/SERVICE/volume.sh
```
