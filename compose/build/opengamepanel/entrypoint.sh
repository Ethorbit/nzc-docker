#!/bin/sh
umask 007

if [ -z $(ls -A /panel/) ]; then
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
    
    # Goto to the database setup step now that we configured it
    curl -k "https://${WEB_PAGE}/install.php?step=2"
fi

exec "$@"
