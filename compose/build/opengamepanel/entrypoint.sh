#!/bin/sh
umask 007

# Any time the volume is empty, we setup an installation
if [ -z $(ls -A /panel/) ]; then
    # Prevent opengamepanel errors before copying anything
    # The admin password must be more than 6 characters:
    
    # Copy the installation files from the docker image
    cp -rap "$HOME"/* /panel/

    # Setup database configuration
    cat <<EOF > /panel/includes/config.inc.php
<?php
\$db_host="${DATABASE_HOST}";
\$db_user="${DATABASE_USER}";
\$db_pass="${DATABASE_PASSWORD}";
\$db_name="${DATABASE_NAME}";
\$table_prefix="ogp_";
\$db_type="mysql";
EOF
    curl -k "https://${WEB_PAGE}/install.php?step=2"

    # Setup admin account
    curl -k -d "username=${ADMIN_USER}" \
        -d "password1=${ADMIN_PASSWORD}" \
        -d "password2=${ADMIN_PASSWORD}" \
        -d "email=${ADMIN_EMAIL}" \
        "https://${WEB_PAGE}/install.php?step=3"

    # Install finished
    rm /panel/install.php
fi

exec "$@"
