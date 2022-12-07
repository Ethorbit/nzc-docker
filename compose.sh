#!/bin/bash
source ".env"
docker-compose $@ || exit 1 &

PORT=27014 # Starts at this + 1
for i in $GMOD_COUNT; do
    SERVER_NUMBER="$i" GMOD_PORT=$(($PORT + 1)) CPU=$(($i - 1)) docker-compose -f "gmod-server.yml" $@
done
