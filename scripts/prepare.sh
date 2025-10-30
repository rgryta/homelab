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
mkdir -p /mnt/archive/apps/volumes/filebrowser/slow
chown -R 1000:1000 /mnt/archive/apps/volumes/filebrowser

## Mail
### Roundcube
mkdir -p /mnt/quick/apps/volumes/roundcube/www
mkdir -p /mnt/quick/apps/volumes/roundcube/sqlite
chown -R 1000:1000 /mnt/quick/apps/volumes/roundcube
### Mailserver
mkdir -p /mnt/quick/apps/volumes/mailserver/data
mkdir -p /mnt/quick/apps/volumes/mailserver/state
mkdir -p /mnt/quick/apps/volumes/mailserver/config
mkdir -p /mnt/quick/apps/volumes/mailserver/dovecot
chown -R root:root /mnt/quick/apps/volumes/mailserver
chmod -R 777 /mnt/quick/apps/volumes/mailserver

## Jellyfin
### NVMe vdev for config and cache
mkdir -p /mnt/quick/apps/volumes/jellyfin/config
mkdir -p /mnt/quick/apps/volumes/jellyfin/cache
chown -R 1000:1000 /mnt/quick/apps/volumes/jellyfin
### Archive mount for media
mkdir -p /mnt/archive/media
chown -R 1000:1000 /mnt/archive/media

## Pi-hole
mkdir -p /mnt/quick/apps/volumes/pihole/pihole
mkdir -p /mnt/quick/apps/volumes/pihole/dnsmasq
chown -R 1000:1000 /mnt/quick/apps/volumes/pihole

## Prometheus
mkdir -p /mnt/quick/apps/volumes/prometheus/config
mkdir -p /mnt/quick/apps/volumes/prometheus/data
chown -R 1000:1000 /mnt/quick/apps/volumes/prometheus
