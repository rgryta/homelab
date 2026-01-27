#!/bin/bash
# Volume setup for LLDAP

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/lldap/data"
chown -R 1000:1000 "$QUICK/lldap"
