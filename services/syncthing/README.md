# syncthing

## Design notes

- The GUI is not published through Traefik. It is reached over WireGuard at `http://172.20.0.108:8384`. Publishing it would need an authentik application for `syncthing.gryta.eu`, which does not exist.
