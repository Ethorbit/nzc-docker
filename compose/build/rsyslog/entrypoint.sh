#!/bin/sh
readonly RSYSLOG_PID_FILE="/var/run/rsyslogd.pid"
readonly RSYSLOG_ARGS="$@"

start_rsyslog() {
    echo "Starting rsyslog.."
    pkill rsyslogd
    rm "$RSYSLOG_PID_FILE" 2> /dev/null
    /usr/sbin/rsyslogd -i "$RSYSLOG_PID_FILE" "$RSYSLOG_ARGS" 2> /dev/null > /dev/null
}

rsyslog_loop() {
    echo "Starting rsyslog loop."

    while :; do
        [ -f "$RSYSLOG_PID_FILE" ] &&\
            [ -d "/proc/$(cat $RSYSLOG_PID_FILE)" ] || start_rsyslog
    
        sleep 2
    done

    echo "rsyslog_loop stopped when it shouldn't have!" ; kill $$ ; exit 1
}

logrotate_loop() {
    echo "Starting logrotate loop."
    
    while :; do
        sleep 1h
        logrotate -v /etc/logrotate.d/
    done

    echo "logrotate_loop stopped when it shouldn't have!" ; kill $$ ; exit 1
}

rsyslog_loop &
logrotate_loop &
sleep infinity
