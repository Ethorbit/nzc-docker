#!/bin/bash 
echo "Merging shared files.."
touch "${SHARED_CACHE}"

# Check cache and remove any broken links before adding more, we don't want clutter!
while read dest; do
    if [[ -d "$dest" ]]; then
        find -L "$dest" -type l -delete
    fi 
done < "${SHARED_CACHE}"

# Merge shared and server using only symlinks
# Save each added symlink to the cache
cp --verbose -ans "${SHARED_DIR}/"* "${SERVER_DIR}/" | awk '{ print $NF }' >> "${SHARED_CACHE}"

echo "Setting file permissions.."
chmod 2770 -fR "${SERVER_DIR}/"

# Now start the steamcmd-server start.sh
# this will also start up the server
exec /start.sh
