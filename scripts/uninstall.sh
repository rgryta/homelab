#!/bin/bash

# For mounting storage from Asus Router:
# mkdir /mnt/asus
# sudo mount -t cifs -o username=test,password=test //192.168.1.1/Drive /mnt/asus

docker-compose -f nginx_revproxy.yaml stop
docker-compose -f filebrowser.yaml stop
docker-compose -f pihole_unbound.yaml stop
docker-compose -f jellyfin.yaml stop
docker-compose -f roundcube.yaml stop
docker-compose -f mail.yaml stop

docker-compose -f nginx_revproxy.yaml rm -v
docker-compose -f filebrowser.yaml rm -v
docker-compose -f pihole_unbound.yaml rm -v
docker-compose -f jellyfin.yaml rm -v
docker-compose -f roundcube.yaml rm -v
docker-compose -f mail.yaml rm -v