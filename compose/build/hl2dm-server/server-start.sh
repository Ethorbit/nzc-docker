#!/bin/bash
#chmod 2770 -R "$SERVER_DIR/"

"${SERVER_DIR}/srcds_run" -game hl2mp -port "${PORT}" -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVERS_DIR}/${STEAMCMD_UPDATE_SCRIPT}" "${START_ARGS}" +sv_setsteamaccount "${STEAM_LOGIN_TOKEN}" +rcon_password "${RCON_PASSWORD}"
