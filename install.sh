#!/bin/sh
if ls -A .*env > /dev/null; then
    cat <<EOF
You have already generated or created .env files.
Either remove them or take the extension out of their names
before installing.
EOF
    exit 1
fi

echo "TODO: replace .env and .users.env in README.MD instructions and just let people generate them with this."
