FROM php:fpm-alpine3.17 AS php-fpm
COPY ./php_packages.txt /
RUN apk add --no-cache $(cat /php_packages.txt)
COPY ./php_extensions.txt /
RUN docker-php-ext-install $(cat /php_extensions.txt)
RUN mkdir /mnt/admin

FROM php-fpm AS php-fpm-development
RUN cp /usr/local/etc/php/php.ini-development $PHP_INI_DIR/conf.d/php.ini &&\
    echo "error_log = /proc/1/fd/2" >> $PHP_INI_DIR/conf.d/php.ini &&\
    echo "access_log = /proc/1/fd/2" >> $PHP_INI_DIR/conf.d/php.ini &&\
    echo "fastcgi.logging = On" >> $PHP_INI_DIR/conf.d/php.ini &&\
    echo "display_errors = stderr" >> $PHP_INI_DIR/conf.d/php.ini

FROM php-fpm AS php-fpm-production
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/conf.d/php.ini &&\
    echo "error_log = /proc/1/fd/2" >> $PHP_INI_DIR/conf.d/php.ini &&\
    echo "access_log = /proc/1/fd/2" >> $PHP_INI_DIR/conf.d/php.ini &&\
    echo "fastcgi.logging = On" >> $PHP_INI_DIR/conf.d/php.ini



FROM php:cli-alpine3.17 AS php-cron
ARG UID 
ARG GID
COPY ./php_packages.txt /
RUN apk add --no-cache $(cat /php_packages.txt)
COPY ./php_extensions.txt /
RUN docker-php-ext-install $(cat /php_extensions.txt)
RUN apk add --no-cache \
        shadow \
        supercronic &&\
    groupadd -g ${GID} php &&\
    useradd -u ${UID} -g php php
USER php

FROM php-cron AS php-cron-development
COPY --from=php-fpm-development $PHP_INI_DIR/conf.d/php.ini $PHP_INI_DIR/conf.d/cli.ini

FROM php-cron AS php-cron-production
COPY --from=php-fpm-production $PHP_INI_DIR/conf.d/php.ini $PHP_INI_DIR/conf.d/cli.ini
