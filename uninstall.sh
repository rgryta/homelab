#!/bin/bash

# For mounting storage from Asus Router:
# mkdir /mnt/asus
# sudo mount -t cifs -o username=test,password=test //192.168.1.1/Drive /mnt/asus

docker-compose -f nginx_revproxy.yaml stop -v
docker-compose -f filebrowser.yaml stop -v
docker-compose -f pihole_unbound.yaml stop -v
docker-compose -f jellyfin.yaml stop -v