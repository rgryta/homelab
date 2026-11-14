# Setup

## OIDC Config

Follow instructions from: https://integrations.goauthentik.io/media/jellyfin/#oidc-configuration
Do not set up roles section - just admin. Roles seem to be broken.
Change scheme to https (at the bottom).

## LLDAP Config (old)
Install LDAP plugin and follow official instructions.
For setup - provide IP of the LDAP server rather than `lldap` hostname.

## Design notes

- The `jellyseerr-legacy` router redirects the old `jellyseerr.gryta.eu` hostname. It runs before forward-auth so existing bookmarks keep working.
