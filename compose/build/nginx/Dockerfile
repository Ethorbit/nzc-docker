FROM nginxinc/nginx-unprivileged:1.23-alpine-perl
ARG UID
ARG GID
USER root
RUN apk add --no-cache shadow &&\
    rm /usr/share/nginx/html/*.html &&\
    usermod -u "$UID" nginx &&\
    groupmod -g "$GID" nginx
USER nginx
