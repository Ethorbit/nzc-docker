FROM ethorbit/mkcert:latest
COPY ./*.sh /
RUN chmod +x /*.sh &&\
    apk add --no-cache openssl
ENTRYPOINT [ "/entrypoint.sh" ]
