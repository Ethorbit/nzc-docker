FROM php:fpm-alpine3.17 as php_fpm
RUN docker-php-ext-install pdo pdo_mysql

FROM php_fpm as development
RUN cp /usr/local/etc/php/php.ini-development $PHP_INI_DIR/conf.d/php.ini

FROM php_fpm as production
RUN cp /usr/local/etc/php/php.ini-production $PHP_INI_DIR/conf.d/php.ini
