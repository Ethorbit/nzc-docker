FROM ethorbit/mysql-anacron-backup:2083e44
ARG UID
ARG GID
USER root
RUN apk update &&\
    apk add --no-cache shadow &&\
    usermod -u "$UID" mysql-backup &&\
    groupmod -g "$GID" mysql-backup
USER mysql-backup
