#!/bin/sh
#if [ -z $(ls -A /etc/fail2ban/) ]; then
#cp -rap /etc/fail2ban_original/* /etc/fail2ban/
#chown 770 -R /etc/fail2ban/
#fi

exec /usr/bin/fail2ban-server "$@"
