#!/bin/bash
set -e

# NVMe Storage
mkdir -p /mnt/quick/apps/volumes/databases/postgres/data
mkdir -p /mnt/quick/apps/volumes/databases/postgres/tablespaces/nvme_indexes
mkdir -p /mnt/quick/apps/volumes/databases/postgres/tablespaces/nvme_data
mkdir -p /mnt/quick/apps/volumes/databases/postgres/backups
mkdir -p /mnt/quick/apps/volumes/databases/valkey/data
mkdir -p /mnt/quick/apps/volumes/databases/questdb/data
mkdir -p /mnt/quick/apps/volumes/databases/qdrant/data
mkdir -p /mnt/quick/apps/volumes/databases/memgraph/data
mkdir -p /mnt/quick/apps/volumes/databases/memgraph/log
mkdir -p /mnt/quick/apps/volumes/databases/mongodb/data
mkdir -p /mnt/quick/apps/volumes/databases/pgadmin/data
mkdir -p /mnt/quick/apps/volumes/databases/redisinsight/data
mkdir -p /mnt/quick/apps/volumes/databases/redpanda/data
mkdir -p /mnt/quick/apps/volumes/databases/garage/meta

# Archive Storage
mkdir -p /mnt/archive/apps/volumes/databases/postgres/tablespaces/archive_data
mkdir -p /mnt/archive/apps/volumes/databases/garage/data

# PostgreSQL (UID 70 on Alpine)
chown -R 70:70 /mnt/quick/apps/volumes/databases/postgres
chown -R 70:70 /mnt/archive/apps/volumes/databases/postgres
chmod 700 /mnt/quick/apps/volumes/databases/postgres/tablespaces/nvme_indexes
chmod 700 /mnt/quick/apps/volumes/databases/postgres/tablespaces/nvme_data
chmod 700 /mnt/archive/apps/volumes/databases/postgres/tablespaces/archive_data

# Valkey (UID 999)
chown -R 999:999 /mnt/quick/apps/volumes/databases/valkey

# QuestDB (UID 1000)
chown -R 1000:1000 /mnt/quick/apps/volumes/databases/questdb

# Qdrant (UID 1000)
chown -R 1000:1000 /mnt/quick/apps/volumes/databases/qdrant

# Memgraph (UID 999)
chown -R 999:999 /mnt/quick/apps/volumes/databases/memgraph

# MongoDB (UID 999)
chown -R 999:999 /mnt/quick/apps/volumes/databases/mongodb

# pgAdmin (UID 5050)
chown -R 5050:5050 /mnt/quick/apps/volumes/databases/pgadmin

# RedisInsight (UID 1000)
chown -R 1000:1000 /mnt/quick/apps/volumes/databases/redisinsight

# Redpanda (UID 101)
chown -R 101:101 /mnt/quick/apps/volumes/databases/redpanda

# Garage (UID 1000)
chown -R 1000:1000 /mnt/quick/apps/volumes/databases/garage
chown -R 1000:1000 /mnt/archive/apps/volumes/databases/garage

echo "Database volumes created"
