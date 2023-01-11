# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Configuring
Create a .env file at the root of the project and add the contents:

```
TZ="America/Los_Angeles"

NZC_GID=9000

NGINX_UID=1200
NGINX_PORT=8080

SFTP_UID=1300
SFTP_PORT=8822

GMOD_COUNT=3
GMOD_1_CPU=0
GMOD_2_CPU=2
GMOD_3_CPU=4
GMOD_UID=2000 

DISCORD_CPU=3
DISCORD_STICKY_BOT_TOKEN="The token goes here"

SVENCOOP_CPU=4
SVENCOOP_PORT=1337
SVENCOOP_UID=2100
```

Change as needed.

## Creating
To start:
`make cmd "up"`

If it works, add a -d at the end to keep it in the background.

To remove:
`make cmd "down"`
