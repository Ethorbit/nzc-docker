FROM alpine:latest
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
VOLUME /volume
VOLUME /volume2
ENTRYPOINT [ "/entrypoint.sh" ]
