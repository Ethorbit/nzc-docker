# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Configuring
Create a .env file at the root of the project and add the contents:

```
DATA_DIR="./data"
TZ="America/Los_Angeles"

SFTP_PORT=8822
SFTP_UID=6000
SFTP_GID=6000

GMOD_COUNT=2
GMOD_1_CPU=1
GMOD_2_CPU=2
GMOD_UID=7000 
GMOD_GID=7000

DISCORD_CPU=3
DISCORD_STICKY_BOT_TOKEN="The token goes here"

SVENCOOP_CPU=4
SVENCOOP_PORT=1337
```

## Creating
Instead of using `docker-compose`, execute `compose.sh` 
compose.sh is a wrapper script which takes 2 arguments:
* 1. What you want to setup (gmod, svencoop, discord, webserver, or all) 
* 2. Everything you'd pass to docker-compose

To start:
`./compose.sh all up`

If it works, add a -d at the end to keep it in the background.

To remove:
`./compose.sh all down`

