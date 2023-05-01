#!/bin/sh
if [ -z $(ls -A /panel/) ]; then
    cp -rap "$HOME"/* /panel/
fi

exec "$@"
