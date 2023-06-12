#!/bin/sh
chmod 750 /var/lib/mysql
chown mysql:mysql /var/lib/mysql
exec /usr/local/bin/docker-entrypoint.sh $@
