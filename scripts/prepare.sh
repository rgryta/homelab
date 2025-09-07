#!/bin/bash

# Execute from within Dockge

# Create directories

## Traefik
mkdir -p /mnt/quick/apps/volumes/traefik/data
mkdir -p /mnt/quick/apps/volumes/traefik/letsencrypt
mkdir -p /mnt/quick/apps/volumes/traefik/dynamic
chown -R 1000:1000 /mnt/quick/apps/volumes/traefik

## LLDAP
mkdir -p /mnt/quick/apps/volumes/lldap/data
chown -R 1000:1000 /mnt/quick/apps/volumes/lldap

## Authentik
mkdir -p /mnt/quick/apps/volumes/authentik/db
chown -R 1000:1000 /mnt/quick/apps/volumes/authentik
