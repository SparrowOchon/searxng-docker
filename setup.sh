#!/bin/bash

# Generate the self-signed certificate (valid for 365 days)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem \
  -subj '/CN=localhost/O=SearXNG Self Signed/C=US'

# Set appropriate permissions
chmod 600 nginx/ssl/key.pem
chmod 644 nginx/ssl/cert.pem
sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" searxng/settings.yml