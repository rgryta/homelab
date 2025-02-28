docker run --rm -it \
  -v "${PWD}/volumes/certbot/certs/:/etc/letsencrypt/" \
  -v "${PWD}/volumes/certbot/logs/:/var/log/letsencrypt/" \
  -p 80:80 \
  -p 443:443 \
  certbot/certbot renew
