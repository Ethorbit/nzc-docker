FROM ethorbit/gmod-server:0733510
ARG PUID=1000
ARG PGID=1000
ARG UMASK
ENV UMASK=${UMASK}
ENV PORT=27015
ENV STEAMCMD_UPDATE_SCRIPT_NOVALIDATE="steam_update_no_validate.txt"
ENV START_ARGS="-tickrate 33 -disableluarefresh -port ${PORT} +maxplayers 15 +gamemode sandbox +map gm_flatgrass"
COPY ./container-start.sh /start_two.sh
COPY ./server-start.sh "${IMAGE_DIR}/${START_SCRIPT}"
USER root
RUN usermod -u "$PUID" ${USER} &&\
    groupmod -g "$PGID" ${USER} &&\
    chown ${USER}:${USER} /start_two.sh &&\
    chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod 700 /start_two.sh &&\
    chmod 2770 "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chown ${USER}:${USER} -R ${HOME_DIR} &&\
    chown ${USER}:${USER} -R ${IMAGE_DIR}
USER ${USER}
CMD ["/start_two.sh"]
