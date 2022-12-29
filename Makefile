SHELL := /bin/bash 
include .env 

ifndef DISK 
VOLUME_DIR := $(shell docker info | grep "Docker Root" | cut -d ":" -f2 | cut -c2-)

#$(info is it working? $(VOLUME_DIR))
    #[ ! -d "$VOLUME_DIR" ] && export VOLUME_DIR="/var/lib/docker"
    #export DISK=$(df "$VOLUME_DIR" | tail -1 | cut -d " " -f 1)
endif

build:
ifndef GMOD_COUNT
	$(info GMOD_COUNT not specified, defaulting to 1..)
	$(eval GMOD_COUNT := 1)
endif 

define seq_gmod 
	$(shell seq ${GMOD_COUNT})
endef 

define GMOD_YAML
$(file < ./gmod_servers.build.yml)
services: $(foreach i,$(seq_gmod),
  unionfs-$i:
    <<: *unionfs
    #container_name: nzc-unionfs-${SERVER_NUMBER}
    volumes:    
      - gmod_$i:/top:shared    
      - gmod_$i_merged:/merged:shared
  gmod-$i:
    <<: *gmod
    #container_name: nzc-gmod-${SERVER_NUMBER}
    #cpuset:
    volumes:
      - gmod_$i_merged:/home/srcds/server 
    depends_on: 
      unionfs:
        condition: service_started
    healthcheck:
      test: ["CMD-SHELL", "findmnt ${VOLUME_DIR} | grep ${HOSTNAME}_merged | grep unionfs"])
volumes: $(foreach i,$(seq_gmod),
  gmod_$i:
  gmod_$i_merged:)
endef

#$(info TEST: $(GMOD_YAML))
