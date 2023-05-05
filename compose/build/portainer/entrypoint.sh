#!/bin/sh
chown -R root:${DATA_GID} /data/
chmod -R 760 /data/
chmod 755 /data

c_loc=/data/.install_cookie

setup_users_and_roles()
{
    echo "Setting up users.."

    #touch /data/.install_completed
}

login_to_admin()
{
    echo "Logging into admin.."
    response=$(curl -ksLf -X POST -H "Content-Type: application/json" \
        -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
        -d "{ \"Username\":\"admin\", \"Password\":\"${PORTAINER_ADMIN_PASSWORD}\" }" \
        "${WEB_PAGE}/api/auth")
    
    [ "$response" -ne 200 ] && echo "Failed to login to admin ($?) - $response" >&2 && sleep 1 && login_to_admin && return
    echo "Response: $response"
}

created_admin=
setup_admin()
{
    [ ! -z "$created_admin" ] && return
    
    echo "Setting up admin account.."
    response=$(curl -ksLf -X POST -H "Content-Type: application/json" \
        -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
        -d "{ \"Username\":\"admin\", \"Password\":\"${PORTAINER_ADMIN_PASSWORD}\" }" \
        "${WEB_PAGE}/api/users/admin/init")
    
    [ "$response" -ne 200 ] && echo "Failed to set the admin password ($?) - $response" >&2 && sleep 1 && setup_admin && return
    created_admin=1
}

start_install()
{
    echo "Install started, waiting for Portainer to start.."
        
    # Wait until Portainer is started and accessible
    while [ ! $(pidof /portainer) ] || [ $(curl -Ikf -o /dev/null -w "%{http_code}\n" "${WEB_PAGE}/") -ne 200 ]; do
        sleep 2
    done

    setup_admin
    login_to_admin
    setup_users_and_roles
}

if [ ! -f /data/.install_completed ]; then
    start_install &
fi

exec /portainer $@
