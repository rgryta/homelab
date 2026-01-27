#!/bin/bash
# Volume setup for Mail (Roundcube + Mailserver)

QUICK="/mnt/quick/apps/volumes"

# Roundcube
mkdir -p "$QUICK/roundcube/www"
mkdir -p "$QUICK/roundcube/sqlite"
chown -R 1000:1000 "$QUICK/roundcube"

# Mailserver
mkdir -p "$QUICK/mailserver/data"
mkdir -p "$QUICK/mailserver/state"
mkdir -p "$QUICK/mailserver/config"
mkdir -p "$QUICK/mailserver/dovecot"
chown -R root:root "$QUICK/mailserver"
chmod -R 777 "$QUICK/mailserver"
