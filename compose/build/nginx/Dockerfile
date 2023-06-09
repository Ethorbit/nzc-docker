FROM nginxinc/nginx-unprivileged:1.23-alpine-perl
ARG UID
ARG GID
USER root
COPY ./*.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*.sh &&\
    chown "$UID":"$GID" /docker-entrypoint.d/*.sh &&\
    apk add --no-cache shadow inotify-tools &&\
    rm /usr/share/nginx/html/*.html &&\
    usermod -u "$UID" nginx &&\
    groupmod -g "$GID" nginx &&\
    mkdir /mnt/admin &&\
    mkdir /mnt/admin/portainer
USER nginx
