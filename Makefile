include .env 
SHELL := /bin/bash 

define newline 


endef

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
# We'll combine the .build.yaml (static) files with the necessary strings here.
define gmod_seq
	$(shell seq ${GMOD_COUNT})
endef

define gmod_yaml 
$(file < ./gmod_servers.build.yml)
services: $(foreach i,$(gmod_seq), \
$(eval cpuset := $(shell test ! -z GMOD_$(i)_CPU && echo cpuset: \"$(GMOD_$(i)_CPU)\")) \
$(newline)  unionfs-$i:
    <<: *unionfs
    $(cpuset)
    volumes:
      - gmod_$i:/top:shared
      - gmod_$i_merged:/merged:shared
  gmod-$i:
    <<: *gmod
    $(cpuset)
    volumes:
      - gmod_$i_merged:/home/srcds/server
    depends_on:
      unionfs-$i:
        condition: service_started
    healthcheck:
      test: ["CMD-SHELL", "findmnt ${VOLUME_DIR} | grep gmod_$i_merged | grep unionfs"])
volumes:  
  <<: *volumes $(foreach i,$(gmod_seq), \
    $(newline)  gmod_$i: \
    $(newline)  gmod_$i_merged: \
)
endef

build: gmod_servers.build.yml
	$(file > ./gmod_servers.yml,$(gmod_yaml))
	$(info $(build_warnings))

define yml_files
$(shell ls *.yml | grep -Ev '(\.build\.yml)' | sed "s/^/-f /")
endef

.PHONY: cmd help 
args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

cmd: build
	DISK=$(DISK) docker-compose $(yml_files) $(args)

define help_text
	make build
	make cmd "compose arguments here" - also calls build
endef

help:
	$(info $(help_text))
