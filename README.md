# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Configuring
Create a .env file at the root of the project and add the contents:

```
DEVELOPING=1

# Dev vars
CA_TRUST_STORE_DIR="/etc/ca-certificates/trust-source"

# Dev / Production vars
PUBLIC_DOMAIN_NAME="nzcservers.com"
PRIVATE_DOMAIN_NAME="chronicles.local"

NGINX_CPU=1

MYSQL_CPU="0-1"

SEARXNG_CPU=1

SSH_PORT=8822

GMOD_1_CPU=0
GMOD_2_CPU=0
GMOD_3_CPU=0

DISCORD_CPU=1
DISCORD_STICKY_BOT_TOKEN=""

SVENCOOP_CPU=1
SVENCOOP_PORT=1337

MYSQL_ADMIN_PASSWORD=""
MYSQL_OGP_PASSWORD=""
MYSQL_GMOD_PASSWORD=""
MYSQL_SVENCOOP_PASSWORD=""

OGP_ADMIN_USER=""
OGP_ADMIN_PASSWORD=""
OGP_ADMIN_EMAIL=""

ADMIN_PASSWORD=""
```

Change as needed.

## Creating
To start:
`make args='up' cmd`

If it works, add a -d at the end to keep it in the background.

To remove:
`make args='down' cmd`

Pass -v after down to also remove the volumes

## Local Testing
* In .env set DEVELOPING to 1 and set PRIVATE\_DOMAIN\_NAME to "chronicles.local"
* In your host, either use dnsmasq and add `address=/chronicles.local/127.0.0.1` to /etc/dnsmasq.conf OR add an /etc/hosts entry `127.0.0.1 chronicles.local` for each subdomain
* After bringing the containers up, restart your browser and then inside set the mkcert certificate to be trusted

## Production Maintenance
Because this project consists of many different containers, it is not feasible to take the entire cluster offline every time you need to make changes. It is also not appropriate to restart individual containers as some have dependency services. You should restart entire files instead of individual containers, this will ensure things like file permissions are set and configuration files are generated from templates when needed.

For example, to restart ONLY the web server:
`nofiles=1 make args='-f ./compose/nginx.yml restart' cmd`

To update users and groups: `make update-users`

