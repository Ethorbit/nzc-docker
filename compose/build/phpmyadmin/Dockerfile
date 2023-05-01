FROM php:fpm-alpine3.17 as install
ARG UID
ARG GID
VOLUME /panel
WORKDIR /home/phpmyadmin
COPY *.sh /
RUN apk add --no-cache shadow git &&\
    groupadd -g ${GID} phpmyadmin &&\
    useradd -u ${UID} -g ${GID} phpmyadmin &&\
    mkdir /panel &&\
    chown phpmyadmin:phpmyadmin /home/phpmyadmin /panel &&\
    chmod 770 /panel &&\
    chmod 755 /*.sh &&\
    chown phpmyadmin:phpmyadmin /*.sh
USER phpmyadmin
RUN git clone -b STABLE https://github.com/phpmyadmin/phpmyadmin.git . &&\
    chmod -R 770 ./
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/start.sh" ]
