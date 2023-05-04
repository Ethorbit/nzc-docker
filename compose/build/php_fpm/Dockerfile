FROM php:fpm-alpine3.17 as modules_for_nzc_websites
RUN docker-php-ext-install pdo pdo_mysql 

FROM modules_for_nzc_websites as modules_for_phpmyadmin
RUN apk add --no-cache php-openssl php-curl \
        php-tokenizer oniguruma-dev \
        libzip-dev libxml2-dev &&\
    docker-php-ext-install mysqli mbstring \
        zip simplexml xmlwriter xml

#libzip-dev autoconf oniguruma-dev
#bcmath mysqli zip mbstring
#RUN apk add --no-cache make g++ libxml2-dev &&\
#pecl install xmlrpc-1.0.0RC3 &&\
#docker-php-ext-enable xmlrpc &&\

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

#FROM modules_for_phpmyadmin as phpmyadmin_prepare
#ARG UID
#ARG GID
#VOLUME /panel
#WORKDIR /home/phpmyadmin
#COPY ./phpmyadmin/*.sh /
#RUN apk add --no-cache shadow git unzip composer yarn &&\
#    groupadd -g ${GID} phpmyadmin &&\
#    useradd -u ${UID} -g ${GID} phpmyadmin &&\
#    mkdir /panel &&\
#    chown phpmyadmin:phpmyadmin /home/phpmyadmin /panel &&\
#    chmod 770 /panel &&\
#    chmod 755 /*.sh &&\
#    chown phpmyadmin:phpmyadmin /*.sh
#
#FROM phpmyadmin_prepare as phpmyadmin
#USER phpmyadmin
#WORKDIR /home/phpmyadmin
##git clone -b STABLE https://github.com/phpmyadmin/phpmyadmin.git . &&\
## ^ that shit takes forever
#RUN curl -fL https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip -o ./phpmyadmin.zip &&\
#    unzip ./phpmyadmin.zip &&\
#    mv ./phpMyAdmin-5.2.1-all-languages/* . &&\
#    rm -R ./phpMyAdmin-5.2.1-all-languages &&\
#    rm ./phpmyadmin.zip &&\
#    chmod -R 770 ./ &&\
#    composer update --ignore-platform-reqs --no-dev
#    #yarn install --production
#ENTRYPOINT [ "/entrypoint.sh" ]
#CMD [ "/start.sh" ]
