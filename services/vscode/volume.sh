#!/bin/bash
# Volume setup for VS Code

QUICK="/mnt/quick/apps/volumes"

mkdir -p "$QUICK/vscode/config"
mkdir -p "$QUICK/vscode/gcloud"
chown -R 1000:1000 "$QUICK/vscode"
