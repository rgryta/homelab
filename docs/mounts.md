# Mounts

How containers get their files. Every stack follows these rules.

## Directories: a named volume bound to a host folder

```yaml
services:
  sonarr:
    volumes:
      - sonarr_config:/config
volumes:
  sonarr_config:
    driver_opts:
      type: none
      o: bind
      device: /mnt/quick/apps/volumes/arr/sonarr/config
```

- No `driver: local`. It is the default.
- Name: `<service>_<purpose>` in snake_case, for example `sonarr_config` or `jam_data`.
- Host folder: `/mnt/quick/apps/volumes/<service>/...` for configuration and data, `/mnt/archive/apps/volumes/<service>/...` for bulk or cold data. Shared media and dataset roots keep their own paths (`/mnt/archive/media/...`, `/mnt/archive/gallery/...`, `/mnt/quick/immich`).
- Read-only access is set on the service line (`jam_music:/music:ro`), not on the volume.
- Data never lives in Docker's own storage. A plain or anonymous volume is not backed up with the rest of `/mnt/quick/apps/volumes`.

## Single files: a direct bind mount

A volume cannot be a single file. Mount it directly and read-only: `valkey.conf`, `garage.toml`, `acme.json`, `prometheus.yml`, wud's `service-worker.js`.

## Exceptions

- `/var/run/docker.sock` (autoheal, wud, traefik, prometheus, code-server) and the host views of cadvisor and node-exporter.
- wud mounts the stack folders it rewrites at the same path in the container.
- code-server mounts `/mnt` and keeps its tool folders in anonymous volumes.
- Anonymous volumes that an image declares for itself and never uses (MongoDB, the registry, FlareSolverr, Syncthing).

## Changing a volume's folder

Compose will not repoint an existing volume. It asks "Recreate (data will be lost)?" and, without an answer, keeps the old binding. To move one:

1. Stop the stack: `docker compose down`.
2. Copy the data to the new folder and compare the copy.
3. Remove the old volume object: `docker volume rm <project>_<name>`. For a bind-backed volume this never deletes the host folder.
4. Edit the compose file and run `docker compose up -d`.

Removing `driver: local`, renaming a volume or adding one needs no such step.

## Not converted yet

- `messenger-sync` still mounts its profile folder directly.
