## Setup
### Dockge
#### Mounts
 - /dev/dri:/dev/dri
 - /mnt/quick:/mnt/quick
 - /mnt/archive:/mnt/archive

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
 
 - Filebrowser: 172.20.0.101
 - Jellyfin: 172.20.0.102
 - NordVPN Client: 172.20.0.103
 - Roundcube: 172.20.0.104
 - Unbound: 172.20.0.253
 - PiHole: 172.20.0.254


