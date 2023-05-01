FROM php:fpm-alpine3.17 as install
RUN apk add --no-cache libzip-dev autoconf oniguruma-dev &&\
    docker-php-ext-install pdo pdo_mysql bcmath mysqli zip mbstring &&\
    apk add --no-cache make g++ libxml2-dev &&\
    pecl install xmlrpc-1.0.0RC3 &&\
    docker-php-ext-enable xmlrpc &&\
    apk add --no-cache php-openssl php-curl

FROM install as files
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
