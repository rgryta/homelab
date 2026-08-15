#!/bin/sh
# WAHA keeps its sessions and media on disk. whatsapp-sync keeps its archive in
# PostgreSQL; the directory below is only the whisper model cache, which would
# otherwise re-download ~460MB on every container recreate.
mkdir -p /mnt/quick/apps/volumes/waha/sessions /mnt/quick/apps/volumes/waha/media \
         /mnt/quick/apps/volumes/waha/whisper
