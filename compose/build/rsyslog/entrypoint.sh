#!/bin/sh
readonly PID_FILE="/var/run/rsyslogd.pid"
rm "${PID_FILE}" 2> /dev/null
/usr/sbin/rsyslogd -i "${PID_FILE}" "$@"
