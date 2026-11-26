# gryta-site

Static page on the apex domain `gryta.eu` (and `www.gryta.eu`), served by nginx. The router asks Traefik for a Let's Encrypt certificate, so the apex no longer gets the Traefik default certificate.

The page is one file, `html/index.html`. Copy it to `/mnt/quick/apps/volumes/gryta-site/html/` on the NAS. nginx reads it at once, so a page change needs no restart.

## Design notes

- The container runs `nginx-unprivileged` on port 8080 with a read-only root file system and no capabilities.
- The page needs no authentication: it is public on purpose.
- The `wud` filter follows the nginx stable branch (`1.30.x`).
