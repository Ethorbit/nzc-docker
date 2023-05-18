FROM phpmyadmin:5.2.1-fpm-alpine
ARG UID
ARG GID
VOLUME /panel
COPY --chown=www-data:www-data ./*.sh /
USER root
WORKDIR /var/www/html
RUN apk add --no-cache shadow &&\
    groupmod -g ${GID} www-data &&\
    usermod -u ${UID} www-data &&\
    mkdir /panel &&\
    chown -R www-data:www-data ./ &&\
    chmod 770 -R ./ &&\
    chown www-data:www-data /panel &&\
    chmod 770 /panel &&\
    chmod 755 /*.sh &&\
    chown www-data:www-data /*.sh &&\
    echo "Fixing stupid hardcoded config location" &&\
    sed -ri "s/^\s.*'configFile'.*/    'configFile'  => ROOT_PATH . 'config.inc.php',/" ./libraries/vendor_config.php
USER www-data
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/start.sh" ]
