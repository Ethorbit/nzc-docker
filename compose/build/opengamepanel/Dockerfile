FROM alpine:3.17.2 as install
ARG UID
ARG GID
ARG WEBSERVER_UID
ENV DATABASE_HOST="localhost"
ENV DATABASE_USER="admin"
ENV DATABASE_PASSWORD="password"
ENV DATABASE_NAME="ogp"
ENV ADMIN_USER="admin"
ENV ADMIN_PASSWORD="password"
ENV ADMIN_EMAIL=""
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
