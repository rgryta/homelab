#!/bin/bash
# Volume setup for Prometheus stack (Prometheus + Grafana)

QUICK="/mnt/quick/apps/volumes"

# Prometheus
mkdir -p "$QUICK/prometheus/config"
mkdir -p "$QUICK/prometheus/data"
chown -R 1000:1000 "$QUICK/prometheus"

# Grafana
mkdir -p "$QUICK/grafana/data"
chown -R 1000:1000 "$QUICK/grafana"
