#!/bin/sh

# Fail2ban will just crash if any of
# the specified log files don't exist.
# We're just going to create every
# non-existent file specified (no dirs included)
# (AKA what Fail2ban SHOULD do)
for jail_file in /etc/fail2ban/jail.d/*; do
    [ ! -f "$jail_file" ] && continue

    for log_file in $(cat "$jail_file" | grep 'logpath' | cut -d '=' -f 2 | cut -d ' ' -f 2 | sed 's|^[\s]*||'); do
        [ ! -f "$log_file" ] && touch "$log_file" 2> /dev/null &&\
            echo "Created $log_file because it didn't exist."
    done
done

exec /usr/bin/fail2ban-server "$@"
