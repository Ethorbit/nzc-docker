FROM nginxinc/nginx-unprivileged:latest
ARG UID
ARG GID
USER root
RUN rm /usr/share/nginx/html/*.html &&\
    usermod -u "$UID" nginx &&\
    groupmod -g "$GID" nginx
USER nginx
