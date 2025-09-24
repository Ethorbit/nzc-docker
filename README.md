# nZC Docker
Docker infrastructure used by the nZC game community. Runs a database, various web apps and a few game servers. Intended to run on a single host, but nothing's stopping you from using thirdparty tools to set it up on multiple hosts.

## Prerequisites
* a Linux install (outside of a container) with at least 2 CPU threads (for best performance), NVMe storage (For best performance) with 20GB of free disk space, and approximately 2GB of RAM available.
* a domain

Packages:
* docker with a version of 27.5.1 (or later)
* lxcfs (optional)
* envsubst
* iptables
* make
* openssl

Check your version:
* `docker -v`

Make sure lxcfs is running (optional):
* `sudo systemctl enable lxcfs --now`
* `find /var/lib/lxcfs/` You should be seeing many files listed for things like cpu and whatnot

We use lxcfs so that the containerized programs can see the container's resources rather than the host's resources, which helps with performance. If you don't care and don't want to use lxcfs, you can just skip this.

## Installing
* `git clone https://github.com/Ethorbit/nzc-docker.git`
* `cd nzc-docker`
* `make install` 

env files will be generated.

`ls -l .*env`

Open them and change their values as needed.

## Optimizing
Everything runs on a single machine, so edit: `.limits.env` 

**Warning: if Docker stores volumes on a partition, you need to set the DISK manually or containers can't start/stop**

IO limits are applied only to the disk device set by `DISK`. This is because all IO heavy operations take place in volumes, and there is (or should only be) one disk for volumes.

Change which CPU threads each service runs off of.
Keep in mind that the games are single-threaded, so there is no point assigning them more than one thread.

Note that IO speed limits and CPU weights are already configured in the yaml files with no variables provided, they should already be optimized well enough.

## Configuring

You can configure the services in `compose/data`. If there's a template for a file, **use it** or else your changes will get overriden.

### Tokens
Tokens can be modified in the .tokens.env file.

### Users and groups

User configuration is stored inside the .users.env file.

Some games are not free and will require you to login to your Steam account for server installation / updates, so you **need** to set a steam username and that user **needs** to own all the games this project uses (Unless you don't want to host for those games)

You can modify admin passwords, but if you already created the containers then you'll need to delete the portainer and mysql volume (or run sql queries to update the mysql user) and then ALL the containers would need to be restarted.

You can edit the container user configuration inside `compose/data`, but be careful not to override users and groups that containers rely on to function and to only change the optional
ones (There is usually comments inside config files to indicate where custom users are, but just use your best judgement).

Unix users and groups are shared between all containers to make permission management easier, you can configure them in: `compose/data/configs/users/settings.yml`
**Make sure all ids are unique**. If you want to change ids (AKA UID/GID), then you'll need to re-create all containers as well as volumes, or you'll need to manually exec into each affected container and correct their permissions - that's tedious, so make sure not to change ids if you don't want to ever deal with that.

You will also want to configure MySQL database users, databases and access, which is in: `compose/data/configs/mysql/template/init.sql`
A basic understanding of SQL syntax will be required.

Lastly, you'll want to manage the Portainer web panel's users and teams in: `compose/data/configs/portainer/templates`

In case anything was missed, look around in the configs directory.

## Development / Local Environment
* In .env set `DEVELOPING` to 1 and in .domain.env set `DOMAIN_NAME` to nzc.local
* In your host, either use dnsmasq and add `address=/nzc.local/127.0.0.1` to /etc/dnsmasq.conf OR add an /etc/hosts entry `127.0.0.1 nzc.local` and an entry for every subdomain used as well.
* After bringing the containers up, go into your browser and set the mkcert certificate (located in CA\_TRUST\_STORE\_DIR) to be trusted. You may need to restart your browser for this to work.

## Production / Public
* In .env set `DEVELOPING` to 0
* In .domain.env set `DOMAIN_NAME` to the domain you own
* Add the following DNS records for your domain:
    * `Record Type A <IP address>`
    * `Subdomain * Record Type A <IP address>`
    * `Subdomain _acme-challenge Record Type CNAME (with nothing as the value for now)`
    * `Subdomain auth Record Type NS ns-auth.<domain name>`

If something on your system is using port 53, **change it!** acme\_dns will only work on 53 because that is the port outside connections check when it comes to domain validation - It's not optional.

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
Because this project consists of many different containers, it is not feasible to take all the containers offline every time you need to make changes. It is important to keep in mind that most containers have dependencies, so it's better to work with entire files rather than individual containers.

For example, to restart ONLY the web server:
`nofiles=1 make args='-f ./compose/nginx.yml restart' cmd`

To list containers: `docker container ls`

To remove a faulty or outdated container: `docker container rm -f <name>`

To create ONLY the containers that were removed:
`make args='up --no-recreate --build -d' cmd`

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

Staff members can also view rsyslog log files from inside SFTP or from the Portainer web panel covered below.

### Admin Webpanels
Provided from the nginx webserver is an admin page with Portainer and PHPMyAdmin to manage most stuff in the browser. - `https://admin.domain/`

You can use PHPMyAdmin to manage MySQL and Portainer to manage all the containers.

This project relies on a Makefile which Portainer knows nothing about, so it is recommended that you **do not** use Portainer to re-create containers and **only use it to** start, stop, restart, view logs, attach and enter commands. And while possible, it is also not recommended to use it to change users, teams or passwords - do that in the config files and then re-create the container(s).

### Attaching - typing into active processes
Some containers (like games) may need you to enter information such as passwords, commands, etc. You can do so with `docker attach <container name>` or by logging into the Portainer webpage and pressing 'Attach' on the selected container.

Attach does not show any history, but you can check logs for that.

Since attaching gives you control of the process, some key combinations (Such as Ctrl+C) can **Terminate** the process! Care should be taken. In the CLI you can do Ctrl+P,Ctrl+C to detach and in Portainer there should be a Detach button, but you can also just close the browser tab.

### Game logins

Some games will say 'Logging into (your steam name set in .users.env)'. These games are actually waiting for you to enter your account's password and will not proceed installation until you do so.

If you're running the project in the foreground, you'll be able to see which games do this, but if you're not, you'll need to view the logs of each game container and check the last log to see if it wants to login to your account.

You can enter a password in games that need it by 'attaching' to the game. After attaching you should see nothing, but if you type your password and hit enter, the game will login. If you mistype your password, the login will fail and you'll need to delete the game's files from inside SFTP and restart the container so you can try again.

## Troubleshooting
* When starting the project a big error shows up: _Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error setting cgroup config for procHooks process: failed to write "8:2 rbps=10485760": write /sys/fs/cgroup/system.slice/docker_

This is because you didn't set the DISK in the .limits.env file. The Makefile is defaulting the DISK to a partition or volume which Docker cannot use for applying cgroups limits and thus it refuses to start the containers.

* When starting the project, I get _max depth exceeded_

You need to remove all the docker images:
`docker rmi -f $(docker images -a -q)`

* Project is running, but some game server(s) never even install.

The game(s) in question might not be free and are waiting for you to login to your Steam account. Check 'Game logins' section under 'Maintenance' for steps on how to proceed.

* Game(s) not working at all after installation or there are missing files / DLCs.

First try updating the game(s) in question and then restarting their container(s). If that doesn't work, delete all the files for the problematic game(s) using SFTP and then restart their container(s).

* Excessive lag caused by a single container 

Try these stress tests to see if it's really a problem with a container, because this could easily be an issue of the host or hardware. They only run for about a minute, so let them finish one at a time.

    * `nofiles=1 make profile='stresstest_volume' args='-f "./compose/stress_tests.yml" up' cmd`
    * `nofiles=1 make profile='stresstest_io' args='-f "./compose/stress_tests.yml" up' cmd`
    * `nofiles=1 make profile='stresstest_cpu' args='-f "./compose/stress_tests.yml" up' cmd`
    * `nofiles=1 make profile='stresstest_memory' args='-f "./compose/stress_tests.yml" up' cmd`
    * `nofiles=1 make profile='stresstest_full' args='-f "./compose/stress_tests.yml" up' cmd`

## Help 
If you need more info on the makefile, use: `make help`

For understanding cmd arguments, check the [docker compose docs](https://docs.docker.com/compose/reference/).
