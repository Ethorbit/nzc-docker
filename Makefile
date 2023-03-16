include .env
SHELL := /bin/bash 
compose_dir := ./compose
data_dir := $(compose_dir)/data
build_dir := $(compose_dir)/build

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
export_ids := set -a && source "$(compose_dir)/data/users/env" > /dev/null 2>&1 &&
command_base := nofiles=$(nofiles) \
				DISK=$(DISK) HUID=$(shell id -u) HGID=$(shell id -g) \
				docker-compose --env-file .env --profile $(profile) -p nzc
command_update := $(command_base) --profile update -f $(compose_dir)/update.yml up
command_setup_users := $(command_base) --profile setup_users -f $(compose_dir)/users_and_groups.yml up
command_build := $(export_ids) $(command_base) --profile setup_users $(yml_files_build) build
command := $(export_ids) $(command_base) $(yml_files)

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

args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

.PHONY: update-containers update-users cmd rm-vol help

cmd: setup_users build_docker
	$(command) $(args)

update-containers:
	$(command_update)

update-users:
	$(command_setup_users)

# Because Docker likes to make removing volumes an annoying task
rm-vol:
	$(eval rm_command := docker volume rm -f $(args))
	$(eval container_ids := $(shell remd= && while read id; do remd=1 && docker container rm -f $$id; done \
		< <($(rm_command) 3>&1 1>&2- 2>&3- | grep -o "[A-Za-z0-9]\{64\}")) && [[ "$$remd" -eq 1 ]] && $(rm_command))

define help_text
	make cmd "compose arguments here"
		Examples:
			make cmd "up"
			nofiles=1 make cmd -- "-f ./compose/nginx.yml down"
	make update-containers - Updates containers and then restarts those effected.
	make update-users - Re-creates users, automatically called when calling cmd
	make rm-vol - Removes a single Docker volume even if there are conflicting docker containers (It removes those too)
endef

help:
	$(info $(help_text))
