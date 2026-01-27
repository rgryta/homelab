#!/bin/bash
# Volume setup for Jellyfin and Jellyseerr

QUICK="/mnt/quick/apps/volumes"
ARCHIVE="/mnt/archive"

# NVMe vdev for config and cache
mkdir -p "$QUICK/jellyfin/config"
mkdir -p "$QUICK/jellyfin/cache"
chown -R 1000:1000 "$QUICK/jellyfin"

# Jellyseerr config
mkdir -p "$QUICK/jellyseerr/config"
chown -R 1000:1000 "$QUICK/jellyseerr"

# Archive mount for media
mkdir -p "$ARCHIVE/media"
chown -R 1000:1000 "$ARCHIVE/media"
