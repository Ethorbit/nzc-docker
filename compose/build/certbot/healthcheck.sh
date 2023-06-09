#!/bin/sh

# If it's a symlink, we need to treat it a little differently:
[ -L "$PUBLIC_KEY" ] && PUBLIC_KEY=$(readlink -m "$PUBLIC_KEY")
[ -L "$PRIVATE_KEY" ] && PRIVATE_KEY=$(readlink -m "$PRIVATE_KEY")

[ -f "$PUBLIC_KEY" ] && [ -s "$PUBLIC_KEY" ] &&\
    [ -f "$PRIVATE_KEY" ] && [ -s "$PRIVATE_KEY" ] &&\
    openssl x509 -noout -pubkey -in "$PUBLIC_KEY" &&\
    openssl pkey -pubout -noout -in "$PRIVATE_KEY" ||\
    exit 1
