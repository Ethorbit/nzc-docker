#!/bin/sh
# Put our build-time scripts into the letsencrypt volume
cp -rap /hook_scripts/* /etc/letsencrypt/

# If container is set to always restart and the command is set to renew by default, 
# then this should technically double as a janky 6 hour auto-renew
certbot $@ && sleep 6h && exit 0
