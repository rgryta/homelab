#!/bin/bash
# Volume setup for WireGuard

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/wireguard/config"
chown -R 1000:1000 "$QUICK/wireguard"
