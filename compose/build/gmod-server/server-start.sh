#!/bin/bash

# Uncomment for nZombies
#START_ARGS="-tickrate 33 -disableluarefresh +maxplayers 15 +gamemode nzombies +map nz_kino_der_toten"

# Add -autoupdate if you care, but just know that it will take forever fetching updates on each startup, causing server startup to be delayed for no reason..
"${SERVER_DIR}/srcds_run" -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVER_DIR}/${STEAMCMD_UPDATE_SCRIPT_NOVALIDATE}" "-port ${PORT} ${START_ARGS}" +sv_setsteamaccount "${STEAM_LOGIN_TOKEN}" +rcon_password "${RCON_PASSWORD}"
