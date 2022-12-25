#!/bin/bash 
source ".env"
COMPOSING_ALL=0

if [ -z "$DISK" ]; then 
    VOLUME_DIR=$(docker info | grep "Docker Root" | cut -d ":" -f2 | cut -c2-)
    [ ! -d "$VOLUME_DIR" ] && VOLUME_DIR="/var/lib/docker"
    export DISK=$(df "$VOLUME_DIR" | tail -1 | cut -d " " -f 1)
fi 

bg()
{
    $([ $COMPOSING_ALL -eq 1 ] && echo "&")
}

gmod()
{ 
    PORT=27014 # Starts at this + 1
    for i in $(seq $GMOD_COUNT); do
        SERVER_NUMBER="$i" GMOD_PORT=$(($PORT + 1)) CPU=$(($i - 1)) docker-compose -f "gmod-server.yml" $@ &
    done 
}

svencoop()
{
    docker-compose -f "svencoop.yml" $@ $(bg)
}

discord()
{
    docker-compose -f "discord-bots.yml" $@ $(bg)
}

webserver()
{
    docker-compose -f "nginx.yml" $@ $(bg)
}

all()
{
    COMPOSING_ALL=1
    gmod $@
    svencoop $@
    discord $@
    webserver $@
}

case "$1" in
    gmod|svencoop|discord|webserver|all)
        $@
    ;;
    *)
        echo "First argument must be: 
        gmod
        svencoop
        discord
        webserver
        all
        "
    ;;
esac 
