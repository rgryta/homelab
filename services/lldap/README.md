# Setup

Created personal user to replace the original admin user. Relogged after making personal user the admin.

Created lldap_family_member group. 

## Design notes

- Password reset by e-mail is off. To enable it, add these variables to the `lldap` environment, with real SMTP values:

  ```yaml
  LLDAP_SMTP_OPTIONS__ENABLE_PASSWORD_RESET: "true"
  LLDAP_SMTP_OPTIONS__SERVER: "smtp.example.com"
  LLDAP_SMTP_OPTIONS__PORT: "587"
  LLDAP_SMTP_OPTIONS__SMTP_ENCRYPTION: "STARTTLS"
  LLDAP_SMTP_OPTIONS__USER: "no-reply@example.com"
  LLDAP_SMTP_OPTIONS__PASSWORD: "your-smtp-password"
  LLDAP_SMTP_OPTIONS__FROM: "no-reply <no-reply@example.com>"
  LLDAP_SMTP_OPTIONS__TO: "admin <admin@example.com>"
  ```
