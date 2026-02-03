# Setup

Once the services are spun up, two modifications are needed for roundcube and docker-mailserver to properly use OAUTH2 with authentik.

## Authentik

Follow the setup of Authentik Application with Oauth2 Provider - note redirect URL might be out of date - refer to documentation from roundcube or from the logs.

## Roundcube

Within roundcube container, append to file `/var/www/html/config/config.inc.php`:

```php
    $config['oauth_provider'] = 'generic';
    $config['oauth_provider_name'] = 'authentik';
    $config['oauth_client_id'] = 'CLIENT_ID';
    $config['oauth_client_secret'] = 'CLIENT_SECRET';
    $config['oauth_auth_uri'] = 'https://authentik.gryta.eu/application/o/authorize/';
    $config['oauth_token_uri'] = 'https://authentik.gryta.eu/application/o/token/';
    $config['oauth_identity_uri'] = 'https://authentik.gryta.eu/application/o/userinfo/';
	
    $config['oauth_scope'] = "email openid profile";
    $config['oauth_auth_parameters'] = [];
    $config['oauth_identity_fields'] = ['email'];
    $config['oauth_login_redirect'] = true;
    $config['use_https'] = true;
```

## Docker-mailserver

Within mailserver container, append to file `/etc/dovecot/dovecot-oauth2.conf.ext` so that the contents look like this:

```conf
introspection_url = https://${CLIENT_ID}:${CLIENT_SECRET}@authentik.gryta.eu/application/o/introspect/
# Dovecot defaults:
introspection_mode = post
username_attribute = email
tokeninfo_url = https://authentik.gryta.eu/application/o/userinfo/?access_token=
force_introspection = yes
active_attribute = active
active_value = true
```

Then restart both services.

## Sources

 - https://integrations.goauthentik.io/chat-communication-collaboration/roundcube/
 - https://github.com/roundcube/roundcubemail/wiki/Configuration:-OAuth2
 - https://docker-mailserver.github.io/docker-mailserver/latest/config/account-management/supplementary/oauth2/#1-docker-mailserver
 