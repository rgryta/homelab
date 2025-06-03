#!/bin/bash

# For mounting storage from Asus Router:
# mkdir /mnt/asus
# sudo mount -t cifs -o username=test,password=test //192.168.1.1/Drive /mnt/asus

docker-compose -f nginx_revproxy.yaml up -d
docker-compose -f filebrowser.yaml up -d
docker-compose -f pihole_unbound.yaml up -d
docker-compose -f jellyfin.yaml up -d
docker-compose -f mail.yaml up -d
docker-compose -f roundcube.yaml up -d

# For adding an email, execute:
# docker exec -ti <CONTAINER NAME> setup email add user@example.com