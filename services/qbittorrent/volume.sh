#!/bin/bash
# Volume setup for qBittorrent

QUICK="/mnt/quick/apps/volumes"
ARCHIVE="/mnt/archive/apps/volumes"

mkdir -p "$QUICK/qbittorrent/config"
chown -R 1000:1000 "$QUICK/qbittorrent"

mkdir -p "$ARCHIVE/qbittorrent/downloads"
chown -R 1000:1000 "$ARCHIVE/qbittorrent"
