#!/bin/sh

# Put our build-time scripts into the letsencrypt volume
cp -rap /hook_scripts/* /etc/letsencrypt/

reset_on_invalid_cert()
{
    /healthcheck.sh 2> /dev/null > /dev/null || exit 1
}

# If container is set to always restart and the command is set to renew by default, 
# then this should technically double as a janky 2 hour auto-renew
certbot $@ && reset_on_invalid_cert && sleep 2h && exit 0
