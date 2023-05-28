FROM certbot/certbot:v2.3.0 as certbot
COPY ./entrypoint.sh /
VOLUME /etc/letsencrypt
VOLUME /var/www/certbot
RUN apk add --no-cache git &&\
    chmod +x /entrypoint.sh &&\
    mkdir /hook_scripts &&\
    mkdir /hook_scripts/pre &&\
    mkdir /hook_scripts/deploy &&\
    mkdir /hook_scripts/post

FROM certbot as acme-dns
RUN mkdir acme-dns &&\
    cd acme-dns &&\
    git clone https://github.com/joohoi/acme-dns-certbot-joohoi . &&\
    git checkout 908aefb0ea3925aaeaf78a7ca32e6a526b1bb563 &&\
    chmod +x acme-dns-auth.py &&\
    echo "Making sure acme-dns-auth uses python3" &&\
    sed -i '1 s|#!/usr/bin/env python|#!/usr/bin/env python3|' acme-dns-auth.py &&\
    mv acme-dns-auth.py /hook_scripts/

FROM acme-dns as finish
RUN apk del git
ENTRYPOINT [ "/entrypoint.sh" ]
