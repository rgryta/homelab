# Container hardening

Every service drops all Linux capabilities and cannot gain new privileges. A service adds back only the capabilities it needs to start.

```yaml
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - DAC_OVERRIDE
      - FOWNER
      - SETGID
      - SETUID
    security_opt:
      - no-new-privileges:true
```

## Capability sets

| Kind of service | `cap_add` |
|---|---|
| Runs as a non-root user from the start (`user:` or an image `USER`) | none |
| Starts as root and drops to another user (linuxserver images, Postgres-style entrypoints, Apache) | `CHOWN`, `DAC_OVERRIDE`, `FOWNER`, `SETGID`, `SETUID` |
| Runs as root all the time and needs no file ownership changes (`whoami`, `autoheal`, `wud`) | none |
| Mail server (`docker-mailserver`) | the set above plus `FSETID`, `KILL`, `SYS_CHROOT`, `NET_BIND_SERVICE` |
| jlesage GUI images (`firefox`) | the set above plus `KILL`, `SETPCAP`, `NET_BIND_SERVICE` |
| `cadvisor` | `DAC_OVERRIDE`, `DAC_READ_SEARCH` |

Containers get `net.ipv4.ip_unprivileged_port_start=0` from Docker, so a non-root process can bind port 80 without `NET_BIND_SERVICE`. The jlesage image does not rely on that.

## Read-only root

`read_only: true` with `tmpfs: [/tmp]` is set on services that keep no state in the container: `whoami`, `autoheal`, `complexio`, `jamroom`. Other services write to their root file system at start, so it stays writable.

## How to apply it to a running service

A container cannot change these settings while it runs. Edit the stack, then recreate the service with `docker compose up -d --no-deps <service>`. Check the result with the healthcheck. For a service without a healthcheck, open its web page or read its log, because a missing capability often shows as a restart loop and not as an error.

## Left out on purpose

- `code-server` (`vscode` stack): it is a development box with the Docker socket and `sudo` configured, so `no-new-privileges` would break `sudo` and the capability limit protects nothing the socket does not already give away.
- `bemol-api` and `bemol-worker`: the stack is deployed from another path (see the `bemol` README) and is not recreated from here.
- `pagerduty-auto-ack`: stopped on purpose.
- `postgres`, `valkey`, `traefik`, `pihole`, `unbound`, `wireguard`, `vpn-client`: restarting them interrupts data access, web access, DNS or the VPN. Harden them one at a time, in a quiet period.
