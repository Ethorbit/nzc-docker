#!/bin/sh
if [ -z $(ls -A /panel/) ]; then
    cp -rap /var/www/html/* /panel/
fi

exec "$@"
