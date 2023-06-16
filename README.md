# nZombies Chronicles
Docker infrastructure used by the nZombies Chronicles community. Runs a database, various web apps and a few game servers. Intended to run on a single host, but nothing's stopping you from using thirdparty tools to set it up on multiple hosts.

## Prerequisites
* a Linux install on baremetal or inside a virtual machine with at least 25GB of free disk space and 3GB of RAM available
* a domain

Packages:
* docker with a minimum version of 24.0.0, build 98fdcd769b
* docker-compose with a minimum version of 2.18.1
* envsubst
* iptables
* make
* openssl

Check your versions:
* `docker -v`
* `docker-compose -v`

You can possibly use earlier versions, but if things don't work as expected - that's why.

## Installing
* `git clone https://github.com/Ethorbit/nzombies-chronicles-docker.git`
* `cd nzombies-chronicles-docker`
* `make install` 

env files will be generated.

`ls -l .*env`

Open them and change their values as needed.

## Optimizing
Everything runs on a single machine, so edit: `.limits.env` 

**Warning: if Docker stores volumes on a partition, you need to set the DISK manually or containers can't start/stop**

IO limits are applied only to the disk device set by `DISK`. This is because all IO heavy operations take place in volumes, and there is (or should only be) one disk for volumes.

Change which CPU cores each service runs off of. It is already optimized for a 2 core system by default.
Keep in mind that Garry's Mod and Sven Co-op are single-threaded.

Note that IO speed limits, RAM limits, and CPU weights are already configured in the yaml files with no variables provided, they should already be optimized well enough.

## Configuring

You can configure the services in `compose/data`. If there's a template for a file, **use it** or else your changes will get overriden.

### Tokens
Tokens can be modified in the .tokens.env file.

### Users and groups
You can modify passwords in the .users.env file. All containers would need to be restarted after changes.

You can edit the container user configuration inside `compose/data`, but be careful not to override users and groups that containers rely on to function and to only change the optional
ones (There is usually comments inside config files to indicate where custom users are, but just use your best judgement).

Unix users and groups are shared between all containers to make permission management easier, you can configure them in: `compose/data/configs/users/settings.yml`
**Make sure all ids are unique**. If you want to change ids (AKA UID/GID), then you'll need to re-create all containers as well as volumes, or you'll need to manually exec into each affected container and correct their permissions - that's tedious, so make sure not to change ids if you don't want to ever deal with that.

You will also want to configure MySQL database users, databases and access, which is in: `compose/data/configs/mysql/init.sql.template`
A basic understanding of SQL syntax will be required.

Lastly, you'll want to manage the Portainer web panel's users and teams in: `compose/data/configs/portainer/templates`

Optionally, if you care about the included SearxNG instance (A privacy respecting meta-search engine), you can add a list of trusted IPs or IP CIDR ranges in: `compose/data/configs/nginx/snippets/admin_ips.conf`
By default, anyone can connect to SearxNG.

In case anything was missed, look around in the configs directory.

## Development / Local Environment
* In .env set `DEVELOPING` to 1 and in .domain.env set `DOMAIN_NAME` to chronicles.local
* In your host, either use dnsmasq and add `address=/chronicles.local/127.0.0.1` to /etc/dnsmasq.conf OR add an /etc/hosts entry `127.0.0.1 chronicles.local` and an entry for every subdomain used as well.
* After bringing the containers up, go into your browser and set the mkcert certificate (located in CA\_TRUST\_STORE\_DIR) to be trusted. You may need to restart your browser for this to work.

## Production / Public
* In .env set `DEVELOPING` to 0
* In .domain.env set `DOMAIN_NAME` to the domain you own
* Add the following DNS records for your domain:
    * `Record Type A <IP address>`
    * `Subdomain * Record Type A <IP address>`
    * `Subdomain _acme-challenge Record Type CNAME (with nothing as the value for now)`
    * `Subdomain auth Record Type NS ns-auth.<domain name>`

Make sure `CERTBOT_TESTING` is set to 1 in the .env file.

Now, when you create/start the project (the commands for that are covered in the next topic) you are going to see the acme\_dns container start up, and **it's going to instruct you to set the value of the** \_**acme-challenge subdomain**. It's going to be something similar to this: `1934c552-0197-12a5-1049-6y84931y217.ns-auth.nzcservers.com` Change `.ns-auth.domain` to `.auth.domain`. After adding what it says, wait about a minute. Certbot may fail the dry-run test a few times before your CNAME changes propagate fully. Once it has propagated, Certbot should tell you that the dry run has succeeded, which means it passed the test. There are no real certificates yet since it's in testing mode, so there will be failed healthchecks.

If you're 100% confident that Certbot succeeded in its dry run, go ahead and stop the project. Inside .env change `CERTBOT_TESTING` from 1 to 0 and then start the project up again. (WARNING: If Certbot errors out after this, you may get rate limited and after 50 failures it won't issue any real certificates for a whole week) Certbot should now be able to issue a valid wildcard domain certificate. Once everything starts, visit https://admin.domain and the HTTPS certificate should show as valid.

Note: if the acme\_dns or certbot\_conf volumes are removed, you'll need to redo the whole process. If the IP of the server changes, you may need to re-create the `acme_dns` container or certificate renewal may fail.

## Creating/Removing

### Everything
To start:
`make args='up --build' cmd`

If it works, add a -d after up to keep it in the background.

To remove:
`make args='down' cmd`

Pass -v after down to also remove the volumes (**which will erase all persistent data!**).

### Entire file(s)
This project organizes containers in individual files for better readability. The Makefile targets all files by default, but you can override that and specify individual files if needed. Keep in mind that some files rely on others, but an error message should appear indicating what other files you may need to include.

* `nofiles=1 make args='-f "./compose/file name.yml" down' cmd`
* `nofiles=1 make args='-f "./compose/file name.yml" up --build' cmd`

### A single service
* `docker container ps`
* `make args='stop name' cmd`
* `make args='rm -f name' cmd`
* `make args='up name --no-deps' cmd`

## Maintenance
Because this project consists of many different containers, it is not feasible to take all the containers offline every time you need to make changes. It is also not appropriate to re-create individual containers as some have dependency services. You should re-create entire files instead of individual containers, this will ensure things like file permissions are set and configuration files are generated from templates when needed.

For example, to restart ONLY the web server:
`nofiles=1 make args='-f ./compose/nginx.yml restart' cmd`

To update users and groups: `make update-users`

Note: for Development there's nothing wrong with removing and re-creating everything: `make args='down -v' cmd && make args='up --build' cmd` - however that results in full data loss, so that's dangerous and unacceptable for a Production instance!

### SSH / SFTP
Every user has their own SSH / SFTP access.
This is how you'll manage the files for every service.

### Viewing logs
Beyond using `docker logs` (Documented on Docker's website), you can also do:
* `docker exec -it nzc-rsyslog-1 /bin/sh` 
* `ls -laht /logs/` 
* `cat <file>`

Staff members can also view rsyslog log files from inside SFTP.

### Admin Webpanels
Provided from the nginx webserver is an admin page with Portainer and PHPMyAdmin to manage most stuff in the browser. - `https://admin.domain/`

You can use PHPMyAdmin to manage MySQL and Portainer to manage all the containers.

This project relies on a Makefile which Portainer knows nothing about, so it is recommended that you **do not** use Portainer to re-create containers and **only use it to** start, stop, restart, view logs, attach and enter commands. And while possible, it is also not recommended to use it to change users, teams or passwords - do that in the config files and then re-create the container(s).

## Help 
If you need more info on the makefile, use: `make help`

For understanding cmd arguments, check the [docker compose docs](https://docs.docker.com/compose/reference/).
