include .env
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

.PHONY: install setup change-passwords update-containers update-users cmd rm-vol help

setup:
	@if ls -A .*env > /dev/null; then \
		echo "You have already generated or created .env files."; \
		echo "Either remove them or take the extension out of their names"; \
		echo "before installing."; \
		exit 1; \
	fi; \
	echo "TODO: replace .env and .users.env in README.MD instructions and just let people generate them with this."

change-passwords:
	@echo "TODO: change passwords here."

install: setup change-passwords
	
echo "TODO: replace .env and .users.env in README.MD instructions and just let people generate them with this."

cmd: setup_users build_docker
	$(command) $(args)

update-containers:
	$(command_update)

update-users:
	$(command_setup_users)

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
	make install - Sets up .env configuration templates for you to edit.
	make change-passwords - Randomizes the value of every PASSWORD variable in the users .env file.
	make cmd "compose arguments here"
		Examples:
			make args='up' cmd
			nofiles=1 make args='-f ./compose/nginx.yml down' cmd"
	make update-containers - Updates containers and then restarts those effected.
	make update-users - Re-creates users, automatically called when calling cmd
	make args='volume name' rm-vol - Removes a single Docker volume even if there are conflicting docker containers (It removes those too)
endef

help:
	$(info $(help_text))
