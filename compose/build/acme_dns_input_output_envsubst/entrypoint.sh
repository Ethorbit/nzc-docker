#!/bin/sh
# nsadmin in the config wants @ to be a dot
export ADMIN_EMAIL_DOTS=$(echo "$ADMIN_EMAIL" | sed 's/@/./')
exec /start.sh
