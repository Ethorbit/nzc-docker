FROM php:fpm-alpine3.17 as modules_for_nzc_websites
RUN docker-php-ext-install pdo pdo_mysql 

FROM modules_for_nzc_websites as modules_for_phpmyadmin
RUN apk add --no-cache php-openssl php-curl \
        php-tokenizer oniguruma-dev \
        libzip-dev libxml2-dev &&\
    docker-php-ext-install mysqli mbstring \
        zip simplexml xmlwriter xml bcmath

FROM modules_for_phpmyadmin as files
RUN echo "error_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-production &&\
    echo "access_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-production &&\
    echo "fastcgi.logging = On" >> $PHP_INI_DIR/php.ini-production &&\
    echo "error_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-development &&\
    echo "access_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-development &&\
    echo "fastcgi.logging = On" >> $PHP_INI_DIR/php.ini-development &&\
    mkdir /mnt/admin

FROM files as development
RUN cp /usr/local/etc/php/php.ini-development $PHP_INI_DIR/conf.d/php.ini &&\
    echo "display_errors = stderr" >> $PHP_INI_DIR/conf.d/php.ini

FROM files as production
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/conf.d/php.ini
