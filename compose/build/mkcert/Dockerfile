FROM ethorbit/mkcert:latest
ARG UID
ARG GID
COPY ./*.sh /
RUN chmod +x /*.sh &&\
    apk add --no-cache openssl &&\
    addgroup -g "${GID}" mkcert &&\
    adduser -D -u "${UID}" -G mkcert mkcert &&\
    chown mkcert:mkcert /mnt
ENTRYPOINT [ "/entrypoint.sh" ]
