FROM ethorbit/svencoop-server:latest
ARG PUID
ARG PGID
ARG UMASK
ENV UMASK=${UMASK}
COPY --chown=${USER}:${USER} --chmod=2770 ./server-start.sh "${IMAGE_DIR}/${START_SCRIPT}"
USER root
RUN usermod -u "$PUID" ${USER} &&\ 
   groupmod -g "$PGID" ${USER} &&\ 
   chown ${USER}:${USER} -R ${HOME_DIR} &&\ 
   dpkg-reconfigure -f noninteractive tzdata
USER ${USER}
