FROM nginxinc/nginx-unprivileged:latest
ARG UID
ARG GID
USER root
RUN usermod -u "$UID" nginx &&\
    groupmod -g "$GID" nginx
USER nginx
