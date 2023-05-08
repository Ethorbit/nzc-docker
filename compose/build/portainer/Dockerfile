FROM portainer/portainer-ce:2.18.2-alpine
ARG DATA_GID
ENV PORTAINER_ADMIN_PASSWORD=securepassword
VOLUME /configs
COPY *.sh /
RUN chmod +x /*.sh &&\
    apk add --no-cache curl jq
ENTRYPOINT [ "/entrypoint.sh" ]
