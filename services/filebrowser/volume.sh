#!/bin/bash
# Volume setup for Filebrowser

QUICK="/mnt/quick/apps/volumes"
ARCHIVE="/mnt/archive/apps/volumes"

# NVMe vdev for database and active files
mkdir -p "$QUICK/filebrowser/db"
mkdir -p "$QUICK/filebrowser/data"
chown -R 1000:1000 "$QUICK/filebrowser"

# Archive mount for slow storage
mkdir -p "$ARCHIVE/filebrowser/slow"
chown -R 1000:1000 "$ARCHIVE/filebrowser"
