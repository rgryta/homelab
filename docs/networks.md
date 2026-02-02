# Network Configuration

This homelab uses six isolated Docker networks for logical separation of services.

## homelab-network (172.20.0.0/24)

Main application network for all services.

| Service | Container | IP Address |
|---------|-----------|------------|
| Traefik | traefik | 172.20.0.100 |
| LLDAP | lldap | 172.20.0.10 |
| Authentik | authentik-server | 172.20.0.13 |
| | authentik-worker | 172.20.0.14 |
| Llama.cpp | llama-cpp | 172.20.0.15 |
| Databases | homelab-postgres | 172.20.0.30 |
| | homelab-valkey | 172.20.0.31 |
| | homelab-questdb | 172.20.0.32 |
| | homelab-qdrant | 172.20.0.33 |
| | homelab-memgraph | 172.20.0.34 |
| | homelab-mongodb | 172.20.0.35 |
| | homelab-memgraph-lab | 172.20.0.36 |
| | homelab-mongo-express | 172.20.0.37 |
| | homelab-pgadmin | 172.20.0.38 |
| | homelab-redisinsight | 172.20.0.39 |
| | postgres-exporter | 172.20.0.40 |
| | valkey-exporter | 172.20.0.41 |
| | mongodb-exporter | 172.20.0.42 |
| | homelab-redpanda | 172.20.0.50 |
| | homelab-mlflow | 172.20.0.51 |
| | homelab-registry | 172.20.0.52 |
| | homelab-garage | 172.20.0.53 |
| | homelab-garage-webui | 172.20.0.54 |
| Whoami | whoami | 172.20.0.20 |
| What's Up Docker | wud | 172.20.0.21 |
| Grafana | grafana | 172.20.0.22 |
| Prometheus | prometheus | 172.20.0.23 |
| VS Code | code-server | 172.20.0.25 |
| macOS | macos | 172.20.0.26 |
| Filebrowser | filebrowser | 172.20.0.102 |
| Jellyfin | jellyfin | 172.20.0.103 |
| Roundcube | roundcubemail | 172.20.0.104 |
| Mailserver | mailserver | 172.20.0.105 |
| Jellyseerr | jellyseerr | 172.20.0.106 |
| OpenFoodFacts | openfoodfacts-db | 172.20.0.110 |
| | openfoodfacts-api | 172.20.0.111 |
| Immich | immich_server | 172.20.0.114 |
| WellMate | wellmateio | 172.20.0.150 |
| WireGuard | wireguard | 172.20.0.200 |
| PiHole | pihole | 172.20.0.254 |

## homelab-vpn-network (172.20.2.0/24)

VPN-tunneled network for services requiring privacy/anonymity.

| Service | Container | IP Address |
|---------|-----------|------------|
| Traefik | traefik | 172.20.2.2 |
| VPN Client | vpn-client | 172.20.2.3 |
| Sonarr | sonarr | 172.20.2.4 |
| Radarr | radarr | 172.20.2.5 |
| Prowlarr | prowlarr | 172.20.2.6 |
| FlareSolverr | flaresolverr | 172.20.2.7 |
| Lidarr | lidarr | 172.20.2.8 |
| Bazarr | bazarr | 172.20.2.9 |
| Cleanuparr | cleanuparr | 172.20.2.10 |
| Huntarr | huntarr | 172.20.2.11 |
| Tdarr | tdarr | 172.20.2.12 |
| PiHole | pihole | 172.20.2.13 |
| Jellyseerr | jellyseerr | 172.20.2.14 |

## pihole-network (172.21.0.0/24)

Isolated network for DNS services.

| Service | Container | IP Address |
|---------|-----------|------------|
| PiHole | pihole | 172.21.0.2 |
| Unbound | unbound | 172.21.0.3 |

## immich-network (172.21.1.0/24)

Isolated network for the photo management stack.

| Service | Container | IP Address |
|---------|-----------|------------|
| Immich Server | immich_server | 172.21.1.2 |
| Immich ML | immich_machine_learning | 172.21.1.5 |
| Immich DB | immich_postgres | 172.21.1.4 |
| Immich Redis | immich_redis | 172.21.1.3 |

## monitoring-network (172.22.0.0/24)

Dedicated network for the monitoring stack.

| Service | Container | IP Address |
|---------|-----------|------------|
| Prometheus | prometheus | 172.22.0.2 |
| cAdvisor | cadvisor | 172.22.0.3 |
| Node Exporter | node-exporter | 172.22.0.4 |
| Grafana | grafana | 172.22.0.5 |

## wireguard-network (172.20.3.0/24)

Docker bridge network for WireGuard container.

| Service | Container | IP Address |
|---------|-----------|------------|
| WireGuard | wireguard | 172.20.3.254 |

**Note**: WireGuard container also has IP 172.20.0.200 on homelab-network. VPN clients use separate tunnel subnet 10.8.0.0/24.
