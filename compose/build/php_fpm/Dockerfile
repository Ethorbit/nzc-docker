FROM php:fpm-alpine3.17 as php_fpm
RUN apk add --no-cache libzip-dev autoconf &&\
    docker-php-ext-install pdo pdo_mysql bcmath mysqli zip &&\
    apk add --no-cache make g++ libxml2-dev &&\
    pecl install xmlrpc-1.0.0RC3 &&\
    docker-php-ext-enable xmlrpc

FROM php_fpm as development
RUN cp /usr/local/etc/php/php.ini-development $PHP_INI_DIR/conf.d/php.ini

FROM php_fpm as production
RUN cp /usr/local/etc/php/php.ini-production $PHP_INI_DIR/conf.d/php.ini
