# Homelab

TrueNAS Dockge-based homelab with containerized services.

## Services

| Service | Description |
|---------|-------------|
| [Traefik](services/traefik/) | Reverse proxy with Let's Encrypt SSL |
| [Authentik](services/authentik/) | OAuth2/OIDC authentication provider |
| [LLDAP](services/lldap/) | LDAP directory service |
| [Filebrowser](services/filebrowser/) | Web-based file manager |
| [Mail](services/mail/) | Roundcube + docker-mailserver |
| [Jellyfin](services/jellyfin/) | Media server with Jellyseerr |
| [Arr](services/arr/) | Media automation (Sonarr, Radarr, Prowlarr, Lidarr, Bazarr, Tdarr) |
| [qBittorrent](services/qbittorrent/) | Torrent client (via VPN) |
| [VPN Client](services/vpn-client/) | NordVPN container for tunneled services |
| [WireGuard](services/wireguard/) | VPN server for external client access |
| [Immich](services/immich/) | Photo and video management |
| [VS Code](services/vscode/) | Web-based code editor |
| [GitHub Runner](services/github-runner/) | Self-hosted GitHub Actions runner |
| [macOS](services/macos/) | macOS virtualization |
| [OpenFoodFacts](services/openfoodfacts/) | Food product database API |
| [Prometheus](services/prometheus/) | Monitoring stack (Prometheus, Grafana, cAdvisor) |
| [Databases](services/databases/) | Unified database infrastructure (PostgreSQL, Valkey, QuestDB, Qdrant, Memgraph, MongoDB) |
| [PiHole](services/pihole/) | DNS ad-blocking with Unbound |
| [What's Up Docker](services/wud/) | Container update checker |
| [Llama.cpp](services/llama.cpp/) | Local LLM inference |
| [Whoami](services/whoami/) | Debug service |
| [WellMate](services/wellmate.io/) | Wellness tracking |

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
