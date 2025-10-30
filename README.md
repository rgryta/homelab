## Setup
### Dockge

#### Mounts

 - /dev/dri:/dev/dri
 - /mnt/quick:/mnt/quick
 - /mnt/archive:/mnt/archive
 
#### Labels

Setting labels for dockge in TrueNAS is a pain, but necessary for remote access.

All labels need to be pointing to dockge container of course. See service configs for proper setup. For example:

```yaml
labels:
 - traefik.enable=true
 - traefik.http.routers.dockge.rule=Host(`dockge.gryta.eu`)
 - traefik.http.routers.dockge.entrypoints=websecure
 - traefik.http.routers.dockge.tls.certresolver=le
 - traefik.http.services.dockge.loadbalancer.server.port=31014
 - traefik.http.routers.dockge.middlewares=authentik-forward-auth@docker
 - traefik.http.middlewares.authentik-forward-auth.forwardauth.address=http://authentik-server:9000/outpost.goauthentik.io/auth/traefik
 - traefik.http.middlewares.authentik-forward-auth.forwardauth.trustforwardheader=true
 - traefik.http.middlewares.authentik-forward-auth.forwardauth.authresponseheaders=X-Authentik-Email,X-Authentik-Username,X-Authentik-Groups
```

Once HTTPS and Authentik proxy is set up for proper security - add `DOCKGE_ENABLE_CONSOLE=true` for easier remote shell access.

#### Resources
CPU: 1
Memory: 512MB

## IP Addresses
### homelab-network (172.20.0.0/24)
 - Traefik: 172.20.0.100
 - LLDAP: 172.20.0.10
 - Authentik:
	- Postgres: 172.20.0.11
	- Redis: 172.20.0.12
	- Auth-Server: 172.20.0.13
	- Auth-Worker: 172.20.0.14
 - Whoami: 172.20.0.20
 - Filebrowser: 172.20.0.102
 - WellMate (website): 172.20.0.150
 - Mail:
	- Mailserver: 172.20.0.105
	- Roundcube: 172.20.0.104
 - Jellyfin: 172.20.0.103
 - Llama.cpp: 172.20.0.15
 - PiHole:
	- PiHole: 172.20.0.254
	- Unbound: 172.20.0.253
 - What's up docker: 172.20.0.21
 - Prometheus: 172.20.0.22

### pihole-network (172.21.0.0/24)
 - PiHole:
	- PiHole: 172.21.0.2
	- Unbound: 172.21.0.3

