# Handy docker commands

## Checking which docker process has docker volume mounted (some volumes are not pruned properly) and where
docker ps -a --filter volume=$VOLUME_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Mounts}}"
docker inspect filebrowser | grep -A 5 $VOLUME_NAME