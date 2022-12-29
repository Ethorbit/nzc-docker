#!/bin/bash 
source ".env"
COMPOSE_LIST=()
COMPOSE_ARGS=()
COMPOSE_COMMAND=
COMPOSE_DETACHED=0

if [ -z "$DISK" ]; then 
    export VOLUME_DIR=$(docker info | grep "Docker Root" | cut -d ":" -f2 | cut -c2-)
    [ ! -d "$VOLUME_DIR" ] && export VOLUME_DIR="/var/lib/docker"
    export DISK=$(df "$VOLUME_DIR" | tail -1 | cut -d " " -f 1)
fi 

bg()
{
    $([ $COMPOSE_DETACHED -eq 1 || ${#COMPOSE_LIST[@]} -ge 1 ] && echo "&")
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
    #gmod $@
    #svencoop $@
    #discord $@
    #webserver $@
}

while [ $# -ge 1 ]; do 
    case "$1" in 
        all)
            shift
            exec "$0" gmod svencoop discord webserver $@
        ;;
        gmod|svencoop|discord|webserver)
            COMPOSE_LIST+=$1
        ;;
        *)
            if [ -z "$COMPOSE_COMMAND" ]; then 
                if [ "$1" != "up" && "$1" != "down" ]; then 
                    echo "You can only do up or down with this script."
                    exit 1
                fi 

                [ "$COMPOSE_COMMAND" = "up" && "$1" = "-d" ] && COMPOSE_DETACHED=1

                COMPOSE_COMMAND="$1"
            fi 
            
            COMPOSE_ARGS+=$1
        ;;
    esac 

    shift 1
done 

if [ ${#COMPOSE_LIST[@]} -ge 1 ]; then 
    for i in ${COMPOSE_LIST[@]}; do 
        $i $COMPOSE_ARGS
    done 
else 
    echo "First argument must be: 
        gmod
        svencoop
        discord
        webserver
        all
        "
fi 
