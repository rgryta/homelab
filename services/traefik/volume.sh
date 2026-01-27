#!/bin/bash
# Volume setup for Traefik

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/traefik/data"
mkdir -p "$QUICK/traefik/letsencrypt"
chown -R 1000:1000 "$QUICK/traefik"
