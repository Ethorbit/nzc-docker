FROM alpine:3.17.2
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh &&\
    apk add --no-cache iptables fail2ban
CMD [ "/bin/sh" ]
ENTRYPOINT [ "/entrypoint.sh" ]
