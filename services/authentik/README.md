# Setup
One time setup:
Open `<BASE_URL>/if/flow/initial-setup/` to set up the admin (akadmin) password.

## Add integration for LLDAP
Head over to Admin Console -> Directory -> Federation and Social login, fill the information based on attached instructions:
https://github.com/lldap/lldap/blob/main/example_configs/authentik.md

LDAP syncs every now and then - but can be manually synced.

# Adding Applications

## Applications without LDAP support

Open Applications -> Applications.
Create the application with "Create with Provider".
Name of the application e.g. "Whoami", slug "whoami", policies "any".
Provider: "Proxy Provider" with Authorization flow: "default-provider-authorization-explicit-consent (Authorize Application)".
Type is "Forward auth (single application)" with external host being e.g. "http://whoami.gryta.eu".
Binding - here I add a binding for a group, e.g. lldap_family_member.


## Application with LDAP support