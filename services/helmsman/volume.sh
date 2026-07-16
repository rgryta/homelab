#!/bin/bash
set -e

# Helmsman keeps all state in Postgres (episodes, anti-patterns, proposals, tokens)
# and bakes rules.yaml into the image, so no host volumes are required.
echo "Helmsman: no volumes needed (state lives in homelab-postgres)"
