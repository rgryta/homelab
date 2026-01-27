#!/bin/bash
# Volume setup for Authentik

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/authentik/db"
chown -R 1000:1000 "$QUICK/authentik"
