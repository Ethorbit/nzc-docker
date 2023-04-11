#!/bin/sh
umask 007

if [ -z $(ls -A /mnt) ]; then
    cp -rap "$HOME"/* /panel/
fi

exec "$@"
