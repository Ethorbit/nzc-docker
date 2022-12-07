# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Configuring
Create a .env file at the root of the project and add the contents:

```
TZ="America/Los_Angeles"

SFTP_PORT=22
SFTP_UID=6000
SFTP_GID=6000

GMOD_COUNT=2 # Do not set this higher than the CPU thread count.
GMOD_UID=7000 
GMOD_GID=7000
GMOD_DIR="/srv/gmod"
```

## Creating
Instead of using `docker-compose`, execute `compose.sh` with the usual arguments. 
`compose.sh` is a wrapper script that will automatically create several gmod servers (it was designed to avoid repetitive yaml properties or commands)

To start:
`./compose.sh up -d`

To remove:
`./compose.sh down`

