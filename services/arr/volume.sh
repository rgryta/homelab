#!/bin/bash
# Volume setup for Arr suite

QUICK="/mnt/quick/apps/volumes"
ARCHIVE="/mnt/archive/apps/volumes"

# Arr configs
mkdir -p "$QUICK/arr/sonarr/config"
mkdir -p "$QUICK/arr/radarr/config"
mkdir -p "$QUICK/arr/lidarr/config"
mkdir -p "$QUICK/arr/bazarr/config"
mkdir -p "$QUICK/arr/prowlarr/config"
mkdir -p "$QUICK/arr/cleanuparr/config"
mkdir -p "$QUICK/arr/huntarr/config"
chown -R 1000:1000 "$QUICK/arr"

# Tdarr
mkdir -p "$QUICK/arr/tdarr/server"
mkdir -p "$QUICK/arr/tdarr/configs"
mkdir -p "$QUICK/arr/tdarr/logs"
mkdir -p "$QUICK/arr/tdarr/transcode_cache"
chown -R 1000:1000 "$QUICK/arr/tdarr"

# Media directories (archive)
mkdir -p /mnt/archive/media/All/Shows
mkdir -p /mnt/archive/media/All/Movies
mkdir -p /mnt/archive/media/All/Anime
mkdir -p /mnt/archive/media/All/Music
mkdir -p /mnt/archive/media/All/Books
chown -R 1000:1000 /mnt/archive/media/All
