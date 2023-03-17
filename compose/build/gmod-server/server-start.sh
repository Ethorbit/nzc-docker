#!/bin/bash

# Override the default start_args for nZombies
#START_ARGS="-port ${PORT} -tickrate 33 -disableluarefresh +maxplayers 15 +gamemode nzombies +map nz_kino_der_toten"

"${SERVER_DIR}/srcds_run" -autoupdate -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVER_DIR}/${STEAMCMD_UPDATE_SCRIPT_NOVALIDATE}" "${START_ARGS}"
