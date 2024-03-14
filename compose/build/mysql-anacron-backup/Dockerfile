FROM ethorbit/mysql-anacron-backup:a544bd7
ARG UID
ARG GID
USER root
RUN apk update &&\
    apk add --no-cache shadow &&\
    usermod -u "$UID" mysql-backup &&\
    groupmod -g "$GID" mysql-backup
USER mysql-backup
