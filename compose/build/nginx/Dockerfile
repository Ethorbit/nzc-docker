FROM nginxinc/nginx-unprivileged:1.23-alpine-perl
ARG UID
ARG GID
USER root
RUN apk add --no-cache shadow \
        php-fpm \
        php-pdo &&\
    rm /usr/share/nginx/html/*.html &&\
    usermod -u "$UID" nginx &&\
    groupmod -g "$GID" nginx &&\
    chown nginx:nginx -R /etc/php81/ &&\
    chown nginx:nginx -R /var/log/php81/
USER nginx
CMD [ "/bin/sh", "-c", "php-fpm81 && nginx -g 'daemon off;'" ]
