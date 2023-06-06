#!/bin/sh
[ -f "$PUBLIC_KEY" ] && [ -s "$PUBLIC_KEY" ] &&\
    [ -f "$PRIVATE_KEY" ] && [ -s "$PRIVATE_KEY" ] &&\
    openssl x509 -noout -pubkey -in "$PUBLIC_KEY" 2> /dev/null > /dev/null &&\
    openssl pkey -pubout -noout -in "$PRIVATE_KEY" 2> /dev/null > /dev/null ||\
    exit 1
