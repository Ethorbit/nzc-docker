#!/bin/sh
if [ -z $(ls -A /mnt) ]; then
    cp -rap "$HOME"/* /mnt/
fi

exec "$@"
