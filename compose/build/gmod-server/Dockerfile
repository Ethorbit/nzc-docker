FROM ethorbit/gmod-server:latest
ARG PUID=1000
ARG PGID=1000
ARG UMASK
ENV UMASK=${UMASK}
ENV PORT=27015
ENV SHARED_DIR=/shared
ENV SHARED_CACHE=/shared_cache.txt
ENV STEAMCMD_UPDATE_SCRIPT_NOVALIDATE="steam_update_no_validate.txt"
ENV START_ARGS="-tickrate 33 -disableluarefresh -port ${PORT} +maxplayers 15 +gamemode sandbox +map gm_flatgrass"
COPY ./container-start.sh /start_two.sh
COPY ./server-start.sh "${IMAGE_DIR}/${START_SCRIPT}"
USER root
RUN usermod -u "$PUID" ${USER} &&\
    groupmod -g "$PGID" ${USER} &&\
    touch "${SHARED_CACHE}" &&\
    chown ${USER}:${USER} /start_two.sh &&\
    chown ${USER}:${USER} "${SHARED_CACHE}" &&\
    chown ${USER}:${USER} "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chmod 700 /start_two.sh &&\
    chmod 700 "${SHARED_CACHE}" &&\
    chmod 2770 "${IMAGE_DIR}/${START_SCRIPT}" &&\
    chown ${USER}:${USER} -R ${HOME_DIR} &&\
    chown ${USER}:${USER} -R ${IMAGE_DIR} &&\
    printf '@NoPromptForPassword 1\nforce_install_dir "%s"\nlogin anonymous\napp_update %i\nquit' \
    "$SERVER_DIR" "${APP_ID}" > "${IMAGE_DIR}/${STEAMCMD_UPDATE_SCRIPT_NOVALIDATE}"
    #mkdir -p "${IMAGE_DIR}/garrysmod" &&\
    #mkdir -p "${SHARED_DIR}/garrysmod" &&\
    #ln -sf "${SHARED_DIR}/garrysmod" "${IMAGE_DIR}/garrysmod/overrides" &&\
    #chown ${USER}:${USER} "${IMAGE_DIR}/garrysmod/overrides" &&\
    #rm -dR "${SHARED_DIR}/"
USER ${USER}
CMD ["/start_two.sh"]
