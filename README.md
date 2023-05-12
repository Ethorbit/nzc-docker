# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles Garry's Mod servers. 

## Configuring
Create a .env file at the root of the project and add the variables:

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

PORTAINER_CPU=1

ADMIN_PASSWORD=""
# Custom users AKA your staff members
BERB_PASSWORD=""
BLUNTO_PASSWORD=""
PEPE_PASSWORD=""
FREEMAN_PASSWORD=""
```

Change as needed.

### Users and groups
Unix users and groups are shared between all containers to make permission management easier.
You can configure the Unix users from `compose/data/configs/users/settings.yml`

Be careful not to override users and groups that containers use to function and to only change the optional
ones (There is comments inside to help understand).

You will also want to configure MYSQL database users and database access, which is in `compose/data/configs/mysql/init.sql.template`

Lastly, you'll also want to manage the Portainer web panel's users and teams in `compose/data/configs/portainer/templates`

In case anything was missed, look around in the configs directory because that's where all user management is located.

## Creating
To start:
`make args='up' cmd`

If it works, add a -d after up to keep it in the background.

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

### Admin Webpanels
Included along with the nginx webserver is an admin endpoint with Portainer and PHPMyAdmin to manage most stuff in the browser. 

You can use PHPMyAdmin to manage MYSQL and Portainer to manage all the containers.

This project relies on a Makefile which Portainer knows nothing about, so it is recommended that you do not use it to re-create containers and only use it to start, stop, restart, view logs, attach and enter commands. And while possible, it is also not recommended to use it to change users, teams or passwords inside - do that in the config files and then re-create the container(s).
