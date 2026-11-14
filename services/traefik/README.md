# Setup

Traefik has additional external network access to ix-dockge_default so that dockge could be accessed through it.

## Design notes

- The dashboard (`api@internal`) is reachable only through the authentik router. Port 8080 serves metrics on homelab-network only (`--entrypoints.traefik.address=172.20.0.100:8080`).
- `--entrypoints.websecure.transport.respondingtimeouts.readtimeout=0` disables the read timeout. The default of 60 s kills large or slow uploads, for example Immich.
- The command flags are grouped in this order: entrypoints, providers, ACME, metrics.
