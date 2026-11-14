# Autoheal

`autoheal` restarts a container when its healthcheck reports `unhealthy`. It is opt-in: only containers with the label `autoheal=true` are watched (`AUTOHEAL_CONTAINER_LABEL=autoheal` in the `autoheal` stack).

## When to label a service

Add `autoheal=true` to a service that has a healthcheck and has crashed or hung without restarting properly. A label on a container without a healthcheck does nothing.

Services that run fine do not need it. The core infrastructure (`authentik`, `lldap`, `pihole`, `unbound`, `mailserver`, `wireguard`, the `databases` stack) has no label and does not need one.

## Never label

- `vpn-client`: `qbittorrent` and `slskd` share its network namespace. Restarting it leaves both without a network until they are recreated too, so an automatic restart would make things worse.
- `ix-dockge-dockge-1`: the Dockge app belongs to TrueNAS, not to a stack in this repository.

## Adding the label

A label cannot change on a running container, so the container has to be recreated: `docker compose up -d --no-deps <service>`.
