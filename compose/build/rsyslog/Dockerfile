FROM alpine:3.17.2
ARG UID
ARG GID
ARG PORT
COPY ./entrypoint.sh /
COPY ./healthcheck.sh /
RUN chmod +x /entrypoint.sh &&\
    chmod +x /healthcheck.sh &&\
    apk add --no-cache rsyslog shadow &&\
    mkdir /configs &&\
    chmod 755 /configs &&\
    printf 'module(load="imtcp")\ninput(type="imtcp" port="%s")\n' \
      "$PORT" > /configs/tcp.conf &&\
    chmod 0444 /configs/tcp.conf &&\
    useradd rsyslog &&\
    usermod -u "$UID" rsyslog &&\
    groupmod -g "$GID" rsyslog &&\
    mkdir /socks &&\
    mkdir /logs &&\
    chmod 770 /socks &&\
    chmod 750 /logs &&\
    chown rsyslog:root /socks &&\
    chown rsyslog:rsyslog /logs &&\
    mkdir /logs/daily /logs/weekly /logs/monthly &&\
    chmod 750 /logs/daily /logs/weekly /logs/monthly &&\
    chown rsyslog:rsyslog /logs/daily /logs/weekly /logs/monthly
VOLUME /socks
VOLUME /logs
EXPOSE ${PORT}/tcp
EXPOSE ${PORT}/udp
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/sh" ]
