#!/bin/bash
# Volume setup for macOS

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/macos"
chown -R 1000:1000 "$QUICK/macos"
