FROM ethorbit/gmod-server:latest
ARG PUID=1000
ARG PGID=1000
ARG SHARED_DIR="/shared"
ARG UMASK
ENV UMASK=${UMASK}
ENV PORT=27015
ENV START_ARGS="-tickrate 33 -disableluarefresh -port ${PORT} +maxplayers 15 +gamemode sandbox +map gm_flatgrass"
USER root
RUN usermod -u "$PUID" ${USER} &&\
   groupmod -g "$PGID" ${USER} &&\
   chown ${USER}:${USER} -R ${HOME_DIR} &&\
   chown ${USER}:${USER} -R ${IMAGE_DIR} &&\
   mkdir -p "${IMAGE_DIR}/garrysmod" &&\
   mkdir -p "${SHARED_DIR}/garrysmod" &&\
   ln -sf "${SHARED_DIR}" "${IMAGE_DIR}/garrysmod/overrides" &&\
   chown ${USER}:${USER} "${IMAGE_DIR}/garrysmod/overrides" &&\
   rm -dR "${SHARED_DIR}/"
USER ${USER}
