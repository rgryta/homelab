# Traefik Labels Reference

All services use Traefik labels for routing, TLS, and authentication.

## Basic Router Pattern

```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.SERVICE.rule=Host(`SERVICE.gryta.eu`)
  - traefik.http.routers.SERVICE.entrypoints=websecure
  - traefik.http.routers.SERVICE.tls.certresolver=le
  - traefik.http.services.SERVICE.loadbalancer.server.port=PORT
```

## With Authentik Forward Auth

Add this middleware for protected services:

```yaml
labels:
  - traefik.http.routers.SERVICE.middlewares=authentik-forward-auth@file
```

The `authentik-forward-auth` middleware is defined in Traefik's file provider configuration (`/traefik/data/`).

## Dockge Labels

Setting labels for Dockge in TrueNAS requires manual configuration:

```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.dockge.rule=Host(`dockge.gryta.eu`)
  - traefik.http.routers.dockge.entrypoints=websecure
  - traefik.http.routers.dockge.tls.certresolver=le
  - traefik.http.services.dockge.loadbalancer.server.port=31014
  - traefik.http.routers.dockge.middlewares=authentik-forward-auth@file
```

Once HTTPS and Authentik proxy is set up, add `DOCKGE_ENABLE_CONSOLE=true` for remote shell access.

## Prometheus Scrape Labels

For services exposing metrics:

```yaml
labels:
  - prometheus.scrape=true
  - prometheus.port=PORT
```
