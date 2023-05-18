# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles community. Runs a database, various web apps and a few game servers. Intended to run on a single host, but nothing's stopping you from using thirdparty tools to set it up on multiple hosts.

## Installing 
Run `make install` and it should generate env files for you. Change them as needed.

### Managing Users and groups
You can modify passwords in the .env files.

You can edit the container user configuration inside `compose/data`, but be careful not to override users and groups that containers rely on to function and to only change the optional
ones (There is usually comments inside config files to indicate where custom users are, but just use your best judgement).

Unix users and groups are shared between all containers to make permission management easier, you can configure them in: `compose/data/configs/users/settings.yml`
**Make sure all ids are unique**. If you want to change ids (AKA UID/GID), then you'll need to re-create all containers as well as volumes, or you'll need to manually exec into each affected container and correct their permissions - that's tedious, so make sure not to change ids if you don't want to ever deal with that.

You will also want to configure MYSQL database users, databases and access, which is in: `compose/data/configs/mysql/init.sql.template`
A basic understanding of SQL syntax will be required.

Lastly, you'll want to manage the Portainer web panel's users and teams in: `compose/data/configs/portainer/templates`

In case anything was missed, look around in the configs directory.

## Creating/Removing the containers
To start:
`make args='up' cmd`

If it works, add a -d after up to keep it in the background.

To remove:
`make args='down' cmd`

Pass -v after down to also remove the volumes

## Development / Local Testing
* In .env set DEVELOPING to 1 and set PRIVATE\_DOMAIN\_NAME to "chronicles.local"
* In your host, either use dnsmasq and add `address=/chronicles.local/127.0.0.1` to /etc/dnsmasq.conf OR add an /etc/hosts entry `127.0.0.1 chronicles.local` for each subdomain
* After bringing the containers up, restart your browser and then inside set the mkcert certificate (located in CA\_TRUST\_STORE\_DIR) to be trusted

## Production
* Set DEVELOPING to 0 in .env 
* Set PUBLIC\_DOMAIN to the domain you own 
* Make your domain point to your server

## Production Maintenance
Because this project consists of many different containers, it is not feasible to take all the containers offline every time you need to make changes. It is also not appropriate to re-create individual containers as some have dependency services. You should re-create entire files instead of individual containers, this will ensure things like file permissions are set and configuration files are generated from templates when needed.

For example, to restart ONLY the web server:
`nofiles=1 make args='-f ./compose/nginx.yml restart' cmd`

To update users and groups: `make update-users`

### Admin Webpanels
Provided from the nginx webserver is an admin page with Portainer and PHPMyAdmin to manage most stuff in the browser. 

You can use PHPMyAdmin to manage MySQL and Portainer to manage all the containers.

This project relies on a Makefile which Portainer knows nothing about, so it is recommended that you **do not** use Portainer to re-create containers and only use it to start, stop, restart, view logs, attach and enter commands. And while possible, it is also not recommended to use it to change users, teams or passwords - do that in the config files and then re-create the container(s).

## Help 
If you need more info on the makefile: use `make help`

For understanding cmd arguments, check the [docker compose docs](https://docs.docker.com/compose/reference/).
