FROM alpine:3.17.2
ARG UID
ARG GID
ARG WEBSERVER_UID
VOLUME /mnt
WORKDIR /home/opengamepanel
COPY --chown=${UID}:${GID} --chmod=755 ./entrypoint.sh /entrypoint.sh
RUN apk add --no-cache git shadow &&\
    groupadd -g ${GID} opengamepanel &&\
    useradd -m -u ${UID} -g ${GID} opengamepanel &&\
    chmod 700 /home/opengamepanel &&\
    chown opengamepanel:opengamepanel /home/opengamepanel &&\
    chown ${WEBSERVER_UID}:opengamepanel /mnt &&\
    chmod 1770 /mnt
USER opengamepanel
RUN git clone "https://github.com/OpenGamePanel/OGP-Website" .
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/sh", "-c", "while true; do sleep 5; done" ]
