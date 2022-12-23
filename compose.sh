#!/bin/bash 
source ".env"

[ -z "$DATA_DIR" ] && export DATA_DIR="./data"
[ ! -d "$DATA_DIR" ] && mkdir -p "$DATA_DIR/${gmod,discord}"
mkdir "$DATA_DIR" 2> /dev/null

export DISK=$(df "$DATA_DIR" | tail -1 | cut -d " " -f 1)

gmod()
{ 
    PORT=27014 # Starts at this + 1
    for i in $(seq $GMOD_COUNT); do
        SERVER_NUMBER="$i" GMOD_PORT=$(($PORT + 1)) CPU=$(($i - 1)) docker-compose -f "gmod-server.yml" $@ &
    done 
}

svencoop()
{
    echo "Svencoop $@"
}

discord()
{
    docker-compose -f "discord-bots.yml" $@ || exit 1 &
}

webserver()
{
    echo "Webserver $@"
}

all()
{
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
