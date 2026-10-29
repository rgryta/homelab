#!/bin/bash
# Volume setup for Jellyfin and Seerr

QUICK="/mnt/quick/apps/volumes"
ARCHIVE="/mnt/archive"

# NVMe vdev for config and cache
mkdir -p "$QUICK/jellyfin/config"
mkdir -p "$QUICK/jellyfin/cache"
chown -R 1000:1000 "$QUICK/jellyfin"

# Seerr config (runs as uid 1000)
mkdir -p "$QUICK/seerr/config"
chown -R 1000:1000 "$QUICK/seerr"

# Archive mount for media
mkdir -p "$ARCHIVE/media"
chown -R 1000:1000 "$ARCHIVE/media"
