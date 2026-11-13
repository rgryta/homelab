#!/bin/bash
# Volume setup for Helmsman
set -e

QUICK="/mnt/quick/apps/volumes"

# Rules, groups and hints are private: they are NOT in this repo. Copy hints.yaml, seed.yaml
# and groups.yaml from helmsman-private (knowledge/) into this directory. The image runs as 65532.
mkdir -p "$QUICK/helmsman/knowledge"
chown -R 65532:65532 "$QUICK/helmsman"
chmod 755 "$QUICK/helmsman" "$QUICK/helmsman/knowledge"
chmod 644 "$QUICK"/helmsman/knowledge/*.yaml 2>/dev/null || true
