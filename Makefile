include .env 
SHELL := /bin/bash 
compose_dir := ./compose
build_dir := $(compose_dir)/build

# Used to add newlines into other defines
define newline 


endef

bs := $(strip \)

# We need to save the disk that named docker volumes get created on,
# this is so that the compose file can set IO limits for containers
ifndef DISK
	VOLUME_DIR := $(shell docker info | grep "Docker Root" | cut -d ":" -f2 | cut -c2-)
	VOLUME_DIR := $(shell test ! -d "$(VOLUME_DIR)" && echo "/var/lib/docker" || echo "$(VOLUME_DIR)")
	DISK := $(shell df "$(VOLUME_DIR)" | tail -1 | cut -d " " -f 1)
endif

ifndef GMOD_COUNT
	GMOD_COUNT := 1
	build_warnings := $(build_warnings)$(newline)Using default GMOD_COUNT ($(GMOD_COUNT))
endif 

# Some stuff we want to do with docker-compose can only be done programatically
# We'll combine the .build.yaml (static) files with the necessary programatic strings here.
define gmod_seq
	$(shell seq ${GMOD_COUNT})
endef

define gmod_yaml
$(file < $(compose_dir)/gmod_servers.build.yml)
services: $(foreach i,$(gmod_seq), \
$(eval cpuset := $(shell test ! -z GMOD_$(i)_CPU && echo cpuset: \"$(GMOD_$(i)_CPU)\")) \
$(eval start_port := $(shell echo "$(GMOD_START_PORT) - 1" | bc)) \
$(eval port := $(shell echo "$(start_port) + $(i)" | bc)) \
$(newline)  unionfs-$i:
    <<: *unionfs
    $(cpuset)
    volumes:
      - gmod_shared:/bottom:shared
      - gmod_$i:/top:shared
      - gmod_$i_merged:/merged:shared
  gmod-$i:
    <<: *gmod
    $(cpuset)
    environment:
      <<: *gmod-environment
      SRCDS_RUN_ARGS: "-tickrate 33 -disableluarefresh -port $(port) +maxplayers 15 +gamemode sandbox +map gm_flatgrass"
    volumes:
      - gmod_$i:/home/srcds/server
    ports:
      - $(port):$(port)/udp
    depends_on:
      unionfs-$i:
        condition: service_started 
    healthcheck:
      test: ["CMD-SHELL", "findmnt ${VOLUME_DIR} | grep gmod_$i_merged | grep unionfs"])
volumes:
  gmod_shared:  $(foreach i,$(gmod_seq), \
    $(newline)  gmod_$i: \
    $(newline)  gmod_$i_merged: \
)
endef

# We're also going to generate the server dockerfiles, as they are all mostly identical 
# (This isn't necessary, but complies with the DRY rule)
define srcds_base_dockerfile
ARG PUID
ARG PGID
ARG TZ
ENV TZ=$${TZ}
USER root
RUN usermod -u "$$PUID" srcds &&$(bs)
   groupmod -g "$$PGID" srcds &&$(bs)
   chown srcds:srcds -R /home/srcds &&$(bs)
   ln -snf "/usr/share/zoneinfo/$$TZ" /etc/localtime &&$(bs)
   echo "/usr/share/zoneinfo/$$TZ" > /etc/timezone &&$(bs)
   dpkg-reconfigure -f noninteractive tzdata
USER srcds
endef

define srcds_dockerfile
FROM ethorbit/srcds-server:latest
$(srcds_base_dockerfile)
endef

define svencoop_dockerfile
FROM ethorbit/svencoop-server:latest
$(srcds_base_dockerfile)
endef

define yml_files
$(shell ls $(compose_dir)/*.yml | grep -Ev '(\.build\.yml)' | sed "s/^/-f /")
endef

command := DISK=$(DISK) docker-compose --env-file .env -p nzc $(yml_files)

build: $(compose_dir)/gmod_servers.build.yml $(build_dir)/srcds-server/Dockerfile $(build_dir)/svencoop-server/Dockerfile
	$(file > $(compose_dir)/gmod_servers.yml,$(gmod_yaml))
	$(file > $(build_dir)/srcds-server/Dockerfile,$(srcds_dockerfile))
	$(file > $(build_dir)/svencoop-server/Dockerfile,$(svencoop_dockerfile))
	$(command) build
	$(info $(build_warnings))

.PHONY: cmd help
	
args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
cmd: build
	$(command) $(args)

define help_text
	make build
	make cmd "compose arguments here" - also calls build
endef

help:
	$(info $(help_text))
