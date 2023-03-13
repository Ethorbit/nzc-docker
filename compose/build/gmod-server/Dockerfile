FROM ethorbit/gmod-server:latest
ARG PUID
ARG PGID
ARG UMASK
ENV UMASK=${UMASK}
USER root
RUN usermod -u "$PUID" ${USER} &&\ 
   groupmod -g "$PGID" ${USER} &&\ 
   chown ${USER}:${USER} -R ${HOME_DIR} &&\ 
   dpkg-reconfigure -f noninteractive tzdata
USER ${USER}
