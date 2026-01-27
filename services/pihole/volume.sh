#!/bin/bash
# Volume setup for Pi-hole

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/pihole/pihole"
mkdir -p "$QUICK/pihole/dnsmasq"
chown -R 1000:1000 "$QUICK/pihole"
