FROM alpine:3.17.2
ARG UID
ARG GID
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh &&\
    apk add --no-cache rsyslog shadow &&\
    useradd rsyslog &&\
    usermod -u "$UID" rsyslog &&\
    groupmod -g "$GID" rsyslog &&\
    mkdir /socks &&\
    mkdir /logs &&\
    chmod 770 /socks &&\
    chmod 770 /logs &&\
    chown rsyslog:root /socks &&\
    chown rsyslog:root /logs
VOLUME /socks
VOLUME /logs
EXPOSE 514/tcp
EXPOSE 514/udp
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/sh" ]
