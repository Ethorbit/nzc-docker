FROM ethorbit/discord-server-status:0ac2cf1
USER root
ARG UID
ARG GID
RUN apk update &&\
    apk add --no-cache shadow &&\
    usermod -u "$UID" server-status &&\
    groupmod -g "$GID" server-status
USER server-status
