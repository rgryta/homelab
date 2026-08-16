#!/bin/bash
# Volume setup for Firefox

QUICK="/mnt/quick/apps/volumes"

# NVMe vdev: this is a browser profile — many small reads, and the whole reason the
# container exists is that it survives a redeploy.
mkdir -p "$QUICK/firefox/config"
chown -R 1000:1000 "$QUICK/firefox"
