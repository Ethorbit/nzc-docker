FROM ethorbit/ark-se-server:acedeb2
ARG PUID
ARG PGID
ARG UMASK
ENV UMASK=${UMASK}
COPY ./server-start.sh "${IMAGE_DIR}/${START_SCRIPT}"
USER root
RUN usermod -u "$PUID" ${USER} &&\ 
   groupmod -g "$PGID" ${USER} &&\
   chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
   chown ${USER}:${USER} -R ${HOME_DIR} &&\ 
   chmod 2770 "${IMAGE_DIR}/${START_SCRIPT}"
USER ${USER}
