FROM certbot/certbot:v2.3.0 as certbot
ARG UID
ARG GID
COPY ./*.sh /
RUN chmod +x /*.sh &&\
    apk add --no-cache git coreutils &&\
    mkdir /hook_scripts &&\
    mkdir /hook_scripts/pre &&\
    mkdir /hook_scripts/deploy &&\
    mkdir /hook_scripts/post &&\
    addgroup -g "${GID}" certbot &&\
    adduser -D -u "${UID}" -G certbot certbot &&\
    chown certbot:certbot -R /opt/certbot &&\
    chown certbot:certbot -R /hook_scripts/ &&\
    chown certbot:certbot /etc/letsencrypt/ &&\
    mkdir -p /var/www/certbot &&\
    chown certbot:certbot /var/www/certbot &&\
    chown certbot:certbot -R /var/log &&\
    chown certbot:certbot -R /var/lib/letsencrypt/
VOLUME /etc/letsencrypt
VOLUME /var/www/certbot
USER certbot

FROM certbot as acme-dns
ARG ACMEDNS_URL
RUN mkdir acme-dns &&\
    cd acme-dns &&\
    git clone https://github.com/joohoi/acme-dns-certbot-joohoi . &&\
    git checkout 908aefb0ea3925aaeaf78a7ca32e6a526b1bb563 &&\
    chmod +x acme-dns-auth.py &&\
    echo "Making sure acme-dns-auth uses python3" &&\
    sed -i '1 s|#!/usr/bin/env python|#!/usr/bin/env python3|' acme-dns-auth.py &&\
    echo "Making sure acme-dns-auth uses correct domain" &&\
    sed -i "s|^ACMEDNS_URL.*|ACMEDNS_URL = $ACMEDNS_URL|" acme-dns-auth.py &&\
    mv acme-dns-auth.py /hook_scripts/

FROM acme-dns as finish
USER root
RUN apk del git
USER certbot
ENTRYPOINT [ "/entrypoint.sh" ]
