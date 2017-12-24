#!/usr/bin/env bash

if [ ! -f docker-compose.yml ]; then
  echo "Please run this script from the root of the docker-vip repo."
  exit 1
fi

# Extract domain from .env file.
DOMAIN=$(sed -e '/^DOCKER_DEV_DOMAIN/!d' -e 's/^DOCKER_DEV_DOMAIN[[:blank:]]*=//' -e 's/[[:blank:]]//g' .env)

if [ -z "$DOMAIN" ]; then
  echo "Could not extract DOCKER_DEV_DOMAIN from .env. No certs generated."
  exit 1
fi

WORKDIR="$(pwd)"
CA_ROOTDIR="$WORKDIR/certs/ca-root"
CERT_DIR="$WORKDIR/certs/self-signed"

mkdir -p "$CA_ROOTDIR" "$CERT_DIR"

if [ ! -f "$CA_ROOTDIR/ca.crt" ] || [ ! -f "$CA_ROOTDIR/ca.key" ]; then
  echo "Creating root key and certificate...."
  openssl genrsa -out "$CA_ROOTDIR/ca.key" 2048
  openssl req -x509 -new -nodes \
    -key "$CA_ROOTDIR/ca.key" \
    -days 3650 \
    -out "$CA_ROOTDIR/ca.crt" \
    -subj "/CN=VIP Dev"
else
  echo "Found root key and certificate, skipping...."
fi

if [ ! -f "$CERT_DIR/$DOMAIN.crt" ] || [ ! -f "$CERT_DIR/$DOMAIN.key" ]; then
  echo "Creating self-signed wildcard certificate for $DOMAIN...."
  docker run --rm \
    -v "$CERT_DIR:/certs/out" \
    -v "$CA_ROOTDIR/ca.crt:/certs/ca.pem:ro" \
    -v "$CA_ROOTDIR/ca.key:/certs/ca-key.pem:ro" \
    -e "SSL_EXPIRE=3650" \
    -e "SSL_DNS=*.$DOMAIN" \
    -e "SSL_CERT=/certs/out/$DOMAIN.crt" \
    -e "SSL_CSR=/certs/out/$DOMAIN.csr" \
    -e "SSL_KEY=/certs/out/$DOMAIN.key" \
    -e "SSL_SUBJECT=$DOMAIN" \
    paulczar/omgwtfssl:latest \
    > /dev/null
else
  echo "Found key and self-signed certificate for $DOMAIN, skipping...."
fi
