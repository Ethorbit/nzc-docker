#!/bin/bash 
echo "Merging shared files.."
#touch "${SHARED_CACHE}"

# Merge shared and server using only symlinks
# Save each added symlink to the cache
#        --verbose
cp --preserve=timestamp -dRns "${SHARED_DIR}/"* "${SERVER_DIR}/" #| awk '{ print $NF }' >> "${SHARED_CACHE}"

echo "Setting file permissions.."
chmod 2770 -fR "${SERVER_DIR}/"

# Now start the steamcmd-server's start.sh
exec /start.sh
