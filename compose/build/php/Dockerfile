FROM php:cli-alpine3.17 as php-shared-modules
RUN apk add --no-cache \
        php-openssl \
        php-curl \
        php-tokenizer \
        oniguruma-dev \
        libzip-dev \
        libxml2-dev
RUN docker-php-ext-install \
        mysqli \
        mbstring \
        zip \
        simplexml \
        xmlwriter \
        xml \
        bcmath \
        pdo \
        pdo_mysql


FROM php:fpm-alpine3.17 AS php-fpm
COPY --from=php-shared-modules /usr/local /usr/local
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
COPY --from=php-shared-modules /usr/local /usr/local
RUN apk add --no-cache cronie

FROM php-cron AS php-cron-development
COPY --from=php-fpm-development $PHP_INI_DIR/conf.d/php.ini $PHP_INI_DIR/conf.d/cli.ini

FROM php-cron AS php-cron-production
COPY --from=php-fpm-production $PHP_INI_DIR/conf.d/php.ini $PHP_INI_DIR/conf.d/cli.ini
