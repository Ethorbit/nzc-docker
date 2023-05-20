FROM alpine:3.17.2
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh &&\
    apk add --no-cache rsyslog
EXPOSE 514/tcp
EXPOSE 514/udp
ENTRYPOINT [ "/entrypoint.sh" ]
