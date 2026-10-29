#!/bin/bash
# Volume setup for Moonlight Web

QUICK="/mnt/quick/apps/volumes"

# Moonlight Web (runs as uid 999)
mkdir -p "$QUICK/moonlight-web/server"
chown -R 999:999 "$QUICK/moonlight-web"
