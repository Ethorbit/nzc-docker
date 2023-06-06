#!/bin/sh
[ ! -f "$PRIVATE_KEY" ] && [ ! -f "$PUBLIC_KEY" ] &&\
    mkcert -install &&\
    mkcert -cert-file /mnt/mkcert.pem -key-file /mnt/mkcert.key \
    ${PRIVATE_DOMAIN_NAME} *.${PRIVATE_DOMAIN_NAME}
    
/healthcheck.sh && sleep inf || rm -f "$PUBLIC_KEY" && rm -f "$PRIVATE_KEY" && exit 1
