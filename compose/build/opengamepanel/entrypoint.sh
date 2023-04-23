#!/bin/sh
umask 007

if [ -z $(ls -A /panel/) ]; then
    cp -rap "$HOME"/* /panel/
    curl -k "https://${WEB_PAGE}/install.php?step=2"
fi

exec "$@"
