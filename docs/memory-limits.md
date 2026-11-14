# Memory limits

Every service has a memory limit (`deploy.resources.limits.memory`). The host has no swap, so a limit is a hard ceiling: a container that goes over is killed. Without one, a runaway container can starve the whole host.

## Choosing a value

- Start from the peak working set over the last 14 days (Prometheus, `container_memory_working_set_bytes` from cAdvisor) and take about 2.5 times that.
- Round up to one of: 128M, 256M, 512M, 768M, 1G, 1536M, 2G, 3G, 4G, 6G, 8G, 12G, 16G.
- Give more room to work that comes in bursts and may not be in the window: transcoding (`jellyfin`, `tdarr`), machine learning (`immich`, `whisper-cpp`), browsers (`flaresolverr`, the Instagram and Messenger harvesters), builds (`code-server`), torrents (`qbittorrent`) and databases.
- Give edge services at least 512M to 1G even when they idle small (`traefik`, `pihole`, `vpn-client`): when they die, everything behind them is down.

A limit is not a reservation. Memory is only used while the service needs it.

## Changing a limit on a running container

`docker update --memory 2g --memory-swap 2g <container>` applies at once without a restart. Change the compose file too, so a later recreate keeps it.

## Check

Prometheus, last 14 days, per container: `max_over_time(container_memory_working_set_bytes{name!=""}[14d])`. A container that sits above about 80% of its limit needs a larger one.
