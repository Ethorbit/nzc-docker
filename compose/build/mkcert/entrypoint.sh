#!/bin/sh
[ ! -f "$PRIVATE_KEY" ] && [ ! -f "$PUBLIC_KEY" ] &&\
    mkcert -install &&\
    mkcert -cert-file /mnt/mkcert.pem -key-file /mnt/mkcert.key \
    ${DOMAIN_NAME} *.${DOMAIN_NAME}

chown mkcert:mkcert "$PUBLIC_KEY"
chown mkcert:mkcert "$PRIVATE_KEY"
chmod 650 "$PUBLIC_KEY"
chmod 650 "$PRIVATE_KEY"

/healthcheck.sh 2> /dev/null > /dev/null && sleep inf || rm -f "$PUBLIC_KEY" && rm -f "$PRIVATE_KEY" && exit 1
