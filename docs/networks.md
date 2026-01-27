# Network Configuration

This homelab uses three isolated Docker networks for logical separation of services.

## homelab-network (172.20.0.0/24)

Main application network for all services.

| Service | Container | IP Address |
|---------|-----------|------------|
| Traefik | traefik | 172.20.0.100 |
| LLDAP | lldap | 172.20.0.10 |
| Authentik | authentik-db | 172.20.0.11 |
| | authentik-redis | 172.20.0.12 |
| | authentik-server | 172.20.0.13 |
| | authentik-worker | 172.20.0.14 |
| Llama.cpp | llama-cpp | 172.20.0.15 |
| Whoami | whoami | 172.20.0.20 |
| What's Up Docker | wud | 172.20.0.21 |
| Grafana | grafana | 172.20.0.22 |
| Prometheus | prometheus | 172.20.0.23 |
| Filebrowser | filebrowser | 172.20.0.102 |
| Jellyfin | jellyfin | 172.20.0.103 |
| Roundcube | roundcube | 172.20.0.104 |
| Mailserver | mailserver | 172.20.0.105 |
| WellMate | wellmate | 172.20.0.150 |
| PiHole | pihole | 172.20.0.254 |

## pihole-network (172.21.0.0/24)

Isolated network for DNS services.

| Service | Container | IP Address |
|---------|-----------|------------|
| PiHole | pihole | 172.21.0.2 |
| Unbound | unbound | 172.21.0.3 |

## monitoring-network (172.22.0.0/24)

Dedicated network for the monitoring stack.

| Service | Container | IP Address |
|---------|-----------|------------|
| Prometheus | prometheus | 172.22.0.2 |
| cAdvisor | cadvisor | 172.22.0.3 |
| Node Exporter | node-exporter | 172.22.0.4 |
| Grafana | grafana | 172.22.0.5 |
