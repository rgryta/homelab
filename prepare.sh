#!/bin/bash
# CONFIG:
WEB_PASS=""

SAMBA_USER=""
SAMBA_PASS=""


# nginx
mkdir -p volumes/nginx/data
mkdir -p volumes/nginx/letsencrypt

# pihole
mkdir -p volumes/pihole/pihole
mkdir -p volumes/pihole/dnsmasq

# filebrowser
mkdir -p volumes/filebrowser

# jellyfin
mkdir -p volumes/jellyfin


# Update path
PTH=$(printf '%s\n' "$(pwd)" | sed -e 's/[\/&]/\\&/g')
sed -i 's/<path>/$PTH/g' *.yaml

# Update web password (e.g. for pihole web interface)
PASS=$(printf '%s\n' "$WEB_PASS" | sed -e 's/[\/&]/\\&/g')
sed -i 's/<password>/$PASS/g' *.yaml

# Update SAMBA config
USR=$(printf '%s\n' "$SAMBA_USER" | sed -e 's/[\/&]/\\&/g')
sed -i 's/<smb_user>/$USR/g' *.yaml
PASS=$(printf '%s\n' "$SAMBA_PASS" | sed -e 's/[\/&]/\\&/g')
sed -i 's/<smb_pass>/$PASS/g' *.yaml