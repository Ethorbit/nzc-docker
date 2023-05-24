#!/bin/sh

# Fail2ban will just crash if any of
# the specified log files don't exist.
# We're just going to create every
# non-existent file specified (no dirs included)
# (AKA what Fail2ban SHOULD do)
for path in $(grep -rhEo '(\/[\.|a-zA-Z0-9_-]+)+' /etc/fail2ban/jail.d/); do 
    [ ! -f "$path" ] && touch "$path" 2> /dev/null
done

exec /usr/bin/fail2ban-server "$@"
