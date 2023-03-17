#!/bin/bash
chmod 2770 -R "$SERVER_DIR/"

"${SERVER_DIR}/svends_run" -autoupdate -steam_dir "${STEAMCMD_DIR}" -steamcmd_script "${SERVER_DIR}/${STEAMCMD_UPDATE_SCRIPT}" "${START_ARGS}"
