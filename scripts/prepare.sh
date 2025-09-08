#!/bin/bash

# Execute from within Dockge

## Traefik
mkdir -p /mnt/quick/apps/volumes/traefik/data
mkdir -p /mnt/quick/apps/volumes/traefik/letsencrypt
chown -R 1000:1000 /mnt/quick/apps/volumes/traefik

## LLDAP
mkdir -p /mnt/quick/apps/volumes/lldap/data
chown -R 1000:1000 /mnt/quick/apps/volumes/lldap

## Authentik
mkdir -p /mnt/quick/apps/volumes/authentik/db
chown -R 1000:1000 /mnt/quick/apps/volumes/authentik

## Filebrowser

### NVMe vdev for database and active files
mkdir -p /mnt/quick/apps/volumes/filebrowser/db
mkdir -p /mnt/quick/apps/volumes/filebrowser/data
chown -R 1000:1000 /mnt/quick/apps/volumes/filebrowser

### Archive mount for media
mkdir -p /mnt/archive/apps/volumes/filebrowser/media
chown -R 1000:1000 /mnt/archive/apps/volumes/filebrowser
