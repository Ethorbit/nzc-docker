FROM php:fpm-alpine3.17 as install
RUN apk add --no-cache libzip-dev autoconf &&\
    docker-php-ext-install pdo pdo_mysql bcmath mysqli zip &&\
    apk add --no-cache make g++ libxml2-dev &&\
    pecl install xmlrpc-1.0.0RC3 &&\
    docker-php-ext-enable xmlrpc

FROM install as logs
RUN echo "error_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-production &&\
    echo "access_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-production &&\
    echo "fastcgi.logging = On" >> $PHP_INI_DIR/php.ini-production &&\
    echo "error_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-development &&\
    echo "access_log = /proc/1/fd/2" >> $PHP_INI_DIR/php.ini-development &&\
    echo "fastcgi.logging = On" >> $PHP_INI_DIR/php.ini-development
    
FROM logs as development
RUN cp /usr/local/etc/php/php.ini-development $PHP_INI_DIR/conf.d/php.ini &&\
    echo "display_errors = stderr" >> $PHP_INI_DIR/conf.d/php.ini

FROM logs as production
RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/conf.d/php.ini
