#!/bin/bash
set -e

# NVMe Storage
mkdir -p /mnt/quick/apps/volumes/btx/ib-gateway/settings

# IB Gateway (UID 1000 - ibgateway user)
chown -R 1000:1000 /mnt/quick/apps/volumes/btx/ib-gateway

echo "BTX volumes created"
