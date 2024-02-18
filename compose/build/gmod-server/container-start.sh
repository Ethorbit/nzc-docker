#!/bin/bash 
echo "Setting file permissions.."
chmod 2770 -fR "${SERVER_DIR}/"

# Now start the steamcmd-server's start.sh
exec /start.sh
