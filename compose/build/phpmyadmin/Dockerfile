FROM phpmyadmin:5-fpm-alpine
ARG UID
ARG GID
VOLUME /panel
COPY --chown=www-data:www-data ./*.sh /
USER root
RUN apk add --no-cache shadow &&\
    groupmod -g ${GID} www-data &&\
    usermod -u ${UID} www-data &&\
    mkdir /panel &&\
    chown -R www-data:www-data /var/www/html &&\
    chmod 770 -R /var/www/html/ &&\
    chown www-data:www-data /panel &&\
    chmod 770 /panel &&\
    chmod 755 /*.sh &&\
    chown www-data:www-data /*.sh
USER www-data
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/start.sh" ]
