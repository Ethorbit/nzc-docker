#!/bin/sh
pidof rsyslogd > /dev/null || exit 1
# below does not work and I don't know why
#nc -z -t -w1 127.0.0.1 514 2> /dev/null || exit 1
