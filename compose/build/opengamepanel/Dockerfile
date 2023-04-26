FROM ethorbit/envsubst:latest as envsubst

FROM alpine:3.17.2 as alpine_with_envsubst
COPY --from=envsubst /usr/lib/libintl.so.8 /usr/lib/libintl.so.8
COPY --from=envsubst /usr/lib/libintl.so.8.3.0 /usr/lib/libintl.so.8.3.0
COPY --from=envsubst /usr/local/bin/envsubst /usr/local/bin/envsubst

FROM alpine_with_envsubst as install
ARG UID
ARG GID
ARG WEBSERVER_UID
ENV DATABASE_HOST="localhost"
ENV DATABASE_USER="admin"
ENV DATABASE_PASSWORD="password"
ENV DATABASE_NAME="ogp"
# ( Bind mount in a /configs/includes/config.inc.php.template file )
VOLUME /panel
VOLUME /configs
WORKDIR /home/opengamepanel
COPY --chown=${UID}:${GID} --chmod=755 ./*.sh /
RUN apk add --no-cache curl git shadow &&\
    groupadd -g ${GID} opengamepanel &&\
    useradd -m -u ${UID} -g ${GID} opengamepanel &&\
    chmod 700 /home/opengamepanel &&\
    chown opengamepanel:opengamepanel /home/opengamepanel
USER opengamepanel
RUN git clone "https://github.com/OpenGamePanel/OGP-Website" . &&\
    git checkout cbc2afe0f3a88063b8c80b2cb50039467b7eb2b5 &&\
    chmod -R 770 ./
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/start.sh" ]
