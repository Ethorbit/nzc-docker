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

DOMAIN_NAME="chronicles.local"

NGINX_CPU=1

MYSQL_CPU="0-1"

SEARXNG_CPU=1

SFTP_PORT=8822

GMOD_COUNT=3
GMOD_1_CPU=0
GMOD_1_CPUMAX=40
GMOD_2_CPU=0
GMOD_2_CPUMAX=40
GMOD_3_CPU=0
GMOD_3_CPUMAX=20
GMOD_3_CPUSHARE=256

DISCORD_CPU=1
DISCORD_STICKY_BOT_TOKEN="The bot's token here"

SVENCOOP_CPU=1
SVENCOOP_PORT=1337

DEVELOPING=1

ADMIN_PASSWORD="admin password here"
```

Change as needed.

## Creating
To start:
`make cmd "up"`

If it works, add a -d at the end to keep it in the background.

To remove:
`make cmd "down"`

## Local Testing
* In .env set DEVELOPING to 1 and set DOMAIN_NAME to "chronicles.local"
* In your host, either use dnsmasq and add `address=/chronicles.local/127.0.0.1` to /etc/dnsmasq.conf OR add an /etc/hosts entry `127.0.0.1 chronicles.local` for each subdomain
* After bringing the containers up, restart your browser and then inside set the mkcert certificate to be trusted


