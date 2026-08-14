#!/bin/bash
set -e

# No host volumes. All state lives in the "slack" database on homelab-postgres,
# provisioned once via slack-sync/deploy/provision-slack-db.sql.

echo "Slack stack needs no host volumes"
