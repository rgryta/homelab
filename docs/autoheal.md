# Autoheal

`autoheal` restarts a container when its healthcheck reports `unhealthy`. It is opt-in: only containers with the label `autoheal=true` are watched (`AUTOHEAL_CONTAINER_LABEL=autoheal` in the `autoheal` stack).

Add `autoheal=true` to the `labels` of every service that has a healthcheck, whether the check is in the compose file or in the image. A label on a container without a healthcheck does nothing.

## Not labeled on purpose

- `vpn-client`: `qbittorrent` and `slskd` share its network namespace. Restarting it leaves both without a network until they are recreated too, so an automatic restart would make things worse.
- `ix-dockge-dockge-1`: the Dockge app belongs to TrueNAS, not to a stack in this repository.

## Not labeled yet

Core infrastructure that is recreated with care, because a recreate means an outage for everything behind it: `authentik-server`, `authentik-worker`, `lldap`, `pihole`, `unbound`, `mailserver`, `wireguard` and the containers of the `databases` stack.

## Adding the label

A label cannot change on a running container, so the container has to be recreated: `docker compose up -d --no-deps <service>`.
