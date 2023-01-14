FROM ethorbit/svencoop-server:latest
ARG PUID
ARG PGID
ARG TZ
ENV TZ=${TZ}
USER root
RUN usermod -u "$PUID" srcds &&\
   groupmod -g "$PGID" srcds &&\
   chown srcds:srcds -R /home/srcds &&\
   ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime &&\
   echo "/usr/share/zoneinfo/$TZ" > /etc/timezone &&\
   dpkg-reconfigure -f noninteractive tzdata
USER srcds
