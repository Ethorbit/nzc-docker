FROM alpine:3.17.2
COPY ./start.sh /start.sh
RUN chmod +x /start.sh &&\
    apk add --no-cache acl
CMD ["/start.sh"]
