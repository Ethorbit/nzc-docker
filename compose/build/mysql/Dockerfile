FROM mysql:8.0.32-debian
ARG UID 
ARG GID
COPY --chown=mysql:mysql ./entrypoint.sh /
RUN chmod +x /entrypoint.sh &&\
    groupmod -g ${GID} mysql &&\
    usermod -u ${UID} mysql &&\
    chmod 750 /var/lib/mysql
ENTRYPOINT [ "/entrypoint.sh" ]
