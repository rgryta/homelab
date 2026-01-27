# Storage Configuration

This homelab uses a tiered storage strategy with TrueNAS mounts.

## Mount Points

### /mnt/quick (NVMe)

Fast NVMe storage for performance-critical data:
- Databases (PostgreSQL, SQLite)
- Application configs
- Caches
- Frequently accessed files

### /mnt/archive (HDD)

Archive storage for bulk data:
- Media files (video, audio, images)
- Backups
- Slow-access files

## Dockge Mounts

The Dockge container requires these mounts for service access:

```
/dev/dri:/dev/dri      # GPU passthrough for transcoding
/mnt/quick:/mnt/quick  # NVMe storage
/mnt/archive:/mnt/archive  # Archive storage
```

## Per-Service Volume Locations

Each service has a `volume.sh` script that creates the required directories. Run from within Dockge.

| Service | Quick Storage | Archive Storage |
|---------|---------------|-----------------|
| Traefik | `/mnt/quick/apps/volumes/traefik/` | - |
| LLDAP | `/mnt/quick/apps/volumes/lldap/` | - |
| Authentik | `/mnt/quick/apps/volumes/authentik/` | - |
| Filebrowser | `/mnt/quick/apps/volumes/filebrowser/` | `/mnt/archive/apps/volumes/filebrowser/` |
| Mail | `/mnt/quick/apps/volumes/roundcube/`<br>`/mnt/quick/apps/volumes/mailserver/` | - |
| Jellyfin | `/mnt/quick/apps/volumes/jellyfin/` | `/mnt/archive/media/` |
| PiHole | `/mnt/quick/apps/volumes/pihole/` | - |
| Prometheus | `/mnt/quick/apps/volumes/prometheus/`<br>`/mnt/quick/apps/volumes/grafana/` | - |
