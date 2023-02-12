# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Configuring
Create a .env file at the root of the project and add the contents:

```
DEVELOPING=1

# Dev vars
CA_TRUST_STORE_DIR="/etc/ca-certificates/trust-source"

# Dev / Production vars
TZ="America/Los_Angeles"

NZC_GID=9000

DOMAIN_NAME="chronicles.local"

NGINX_UID=1200
#NGINX_GID=1200

SEARXNG_CPU=4

SFTP_UID=1300
#SFTP_GID=1300
SFTP_PORT=8822

GMOD_COUNT=3
GMOD_1_CPU=0
GMOD_2_CPU=2
GMOD_3_CPU=4
GMOD_UID=2000 
#GMOD_GID=2000

DISCORD_CPU=3
DISCORD_STICKY_BOT_TOKEN="The token goes here"

SVENCOOP_CPU=4
SVENCOOP_PORT=1337
SVENCOOP_UID=2100
#SVENCOOP_GID=2100
```

Change as needed.

## Creating
To start:
`make cmd "up"`

If it works, add a -d at the end to keep it in the background.

To remove:
`make cmd "down"`

# Local Testing
In .env set DEVELOPING to 1

In your host's /etc/hosts, add: 
`127.0.0.1 chronicles.local`
`127.0.0.1 site.chronicles.local`
`127.0.0.1 fastdl.chronicles.local`
`127.0.0.1 search.chronicles.local`

After bringing the containers up, restart your browser and then inside, set the listed mkcert certificate to trusted.
