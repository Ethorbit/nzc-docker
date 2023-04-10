#php8-pecl-xmlrpc
FROM php:fpm-alpine3.17 as php_fpm
RUN apk add --no-cache libzip-dev &&\
    docker-php-ext-install pdo pdo_mysql bcmath mysqli zip
#pecl install channel://pecl.php.net/xmlrpc/1.0.0RC3
FROM php_fpm as development
RUN cp /usr/local/etc/php/php.ini-development $PHP_INI_DIR/conf.d/php.ini

FROM php_fpm as production
RUN cp /usr/local/etc/php/php.ini-production $PHP_INI_DIR/conf.d/php.ini
