-include $(wildcard .*env)

SHELL := /bin/bash 
compose_dir := ./compose
data_dir := $(compose_dir)/data
config_dir := $(data_dir)/configs
build_dir := $(compose_dir)/build

CONTAINER_NAME_PREFIX := nzc
CONTAINER_NAME_SUFFIX := 1 # this is just what Docker does.. Don't think we can control it.

# Used to add newlines into other defines
define newline 


endef

# Used to add equal signs into other defines
define equals
=
endef

bs := $(strip \) # Used to add literal newlines into other defines

# We need to save the disk that named docker volumes get created on,
# this is so that the compose file can set IO limits for containers
ifndef DISK
	VOLUME_DIR := $(shell docker info | grep "Docker Root" | cut -d ":" -f2 | cut -c2-)
	VOLUME_DIR := $(shell test ! -d "$(VOLUME_DIR)" && echo "/var/lib/docker" || echo "$(VOLUME_DIR)")
	DISK := $(shell df "$(VOLUME_DIR)" | tail -1 | cut -d " " -f 1)
endif

list_yml_command := ls $(compose_dir)/*.yml | grep -Ev '(\.build\.yml)' | sed "s/^/-f /"

define yml_files
$(shell [[ "$(nofiles)" -ne 1 ]] && $(list_yml_command))
endef

define yml_files_build
$(shell $(list_yml_command))
endef

profile := $(shell [[ "$(DEVELOPING)" -ge 1 ]] && echo "development" || echo "production")
command_base := set -a && source <(cat .*env "$(config_dir)/users/env") > /dev/null 2>&1 &&\
				nofiles=$(nofiles) \
				DISK=$(DISK) HUID=$(shell id -u) HGID=$(shell id -g) \
				CONTAINER_NAME_PREFIX=$(CONTAINER_NAME_PREFIX) CONTAINER_NAME_SUFFIX=$(CONTAINER_NAME_SUFFIX) \
				docker-compose --profile $(profile) -p $(CONTAINER_NAME_PREFIX)
command_update := $(command_base) --profile update -f $(compose_dir)/update.yml up
command_setup_users := $(command_base) --profile setup_users -f $(compose_dir)/users_and_groups.yml up
command_build := $(command_base) --profile setup_users $(yml_files_build) build --progress plain
command := $(command_base) $(yml_files)

build_docker: $(dir $(wildcard $(build_dir)/**/*))
	$(command_build)
	touch $@

# The containers' users and groups are managed by a service and isolated from the host
# because it generates a dependency .env file that other containers use to specify users and groups, 
# we will run this separately
setup_users: #$(compose_dir)/users_and_groups.yml $(shell find $(data_dir)/users/ -type f)
	$(info We must configure users and groups first)
	$(command_setup_users)
#	touch $@

# This really shouldn't matter because people should be doing 
# make args='' <target> instead of make <target> 'args', but I'm leaving this 
# for compatibility. Only downside is it will exit with error 
# code 2 with 'invalid rule' every time, but other than that, 
# it works just the same.
args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

.PHONY: install setup list-passwords set-passwords update-containers update-users cmd rm-vol help

define gen_pass
$$(openssl rand -base64 $(1) | printf "%s%s\n" "$$(cat -)" '!@#$%^&*()' | fold -w1 | shuf | tr -d '\n')
endef

define rand_int
$$(($$RANDOM % ($(2) - $(1)) + 1))
endef

setup:
	@if ls -A $(CURDIR)/.*env > /dev/null 2> /dev/null; then \
		echo "You have already generated or created .env files."; \
		echo "Either remove them or take the extension out of their names"; \
		echo "before installing."; \
		exit 1; \
	fi; \
	check_cmd() { if ! command -v "$$1" > /dev/null; then echo "$$1 not found, install it." >&2 && exit 1; fi; }; \
	check_cmd docker-compose; \
	check_cmd envsubst; \
	check_cmd openssl; \
	check_cmd find; \
	mkdir -p $(config_dir)/nginx/snippets/private; \
	echo -e '# allow 127.0.0.0/8;\nallow all;' | tee -a $(config_dir)/nginx/snippets/private/admin_ips.conf; \
	export PHPMYADMIN_BLOWFISH_SECRET="$(call gen_pass,15)"; \
	export SEARXNG_SECRET_KEY="$(call gen_pass,15)"; \
	find "$(CURDIR)/install/" -mindepth 1 -maxdepth 1 -type f -name "*env.template" \
	-exec /bin/sh -c 'envsubst < {} > $$(basename -s ".template" {}) && echo "Generated $$(basename {})"' \; ; \
	echo "Go ahead and fill them out and then start the containers. Use make help for more info."

list-passwords:
	@echo "Here are some passwords you can use:"
	@for i in {1..20}; do echo "$$i. $(call gen_pass,$(call rand_int,6,17))"; done

set-passwords:
	@change_file_passwords() { \
		file="$$1" &&\
		echo "$$file"; \
	}; \
	exit; \
	export -f change_file_passwords; \
	find "$(CURDIR)" -mindepth 1 -maxdepth 1 -type f -name ".*env" \
	-exec /bin/sh -c "change_file_passwords {}" \; ; \
	echo "Assigned random passwords."
	
update-users:
	$(command_setup_users)

update-containers:
	$(command_update)

install: setup set-passwords list-passwords

cmd: setup_users build_docker
	$(command) $(args)

# Because Docker likes to make removing volumes an annoying task
define rm-vol_cmd
$(eval rm_command := docker volume rm -f $(args))
$(eval container_ids := $(shell remd= && while read id; do remd=1 && docker container rm -f $$id; done \
	< <($(rm_command) 3>&1 1>&2- 2>&3- | grep -o "[A-Za-z0-9]\{64\}")) && [[ "$$remd" -eq 1 ]] && $(rm_command))
endef

# Not quite sure why it has to run twice to work, but just gonna do this for now..
rm-vol:
	$(rm-vol_cmd)
	$(rm-vol_cmd)

define help_text
Makefile: a wrapper script created to overcome Docker Compose limitations.
   make install 
      - Sets up the necessary .env configuration as a template for you to modify.
	  
	Notes for devs:
	    All .env files are passed to compose, meaning they can be referenced in the yaml files.
	    You can also use env_file to pass them to individual containers.
		
   make set-passwords 
      - Applies a random password to every PASSWORD variable. Additionally lists a bunch of short, but very secure passwords to choose from. When finished, users are updated.
      NOTE: This does not actually do anything currently, the functionality has not been implemented!
	
   make list-passwords
      - Lists a bunch of random and very secure passwords to choose from.

   make args='Docker compose command' cmd
	Examples:
	    make args='up' cmd
	    nofiles=1 make args='-f ./compose/nginx.yml down' cmd

	Note: unless nofiles=1 is specified, ALL yaml files are used.

   make update-containers 
      - Updates containers and then restarts those affected.
      Note: Most containers are version-locked for stability so you'll need to manually bump up their image tags in each yaml file to truly keep them up-to-date. Only containers tagged with :latest can benefit from this.

   make update-users 
     - Re-creates users (automatically called when calling cmd)

   make args='volume name' rm-vol 
      - Removes a single Docker volume even if there are conflicting docker containers (It removes those too). This is only useful if you find yourself needing to repeatedly remove volumes.
endef

help:
	$(info $(help_text))
