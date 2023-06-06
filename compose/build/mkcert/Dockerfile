FROM ethorbit/mkcert:latest
COPY ./healthcheck.sh /
RUN chmod +x /healthcheck.sh &&\
    apk add --no-cache openssl
