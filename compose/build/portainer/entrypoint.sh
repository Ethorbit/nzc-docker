#!/bin/sh
chown -R root:${DATA_GID} /data/
chmod 755 /data

c_loc=/data/.install_cookie
jwt_token=

send_requests_from_file()
{
    file="$1"
    endpoint="$2"
    error_msg="$3"

    for row in $(jq -c '.[]' "$file"); do 
        response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
            -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" -d "$row" "${WEB_PAGE}${endpoint}")

        [ "$response" -ne 200 ] && echo -e "$error_msg ($?) - $response\n$row" >&2 &&\
            sleep 2 && send_requests_from_file "$1" "$2" "$3" && return
    done
}

setup_users()
{
    echo "Adding users.."

    for row in $(jq -c '.[]' /configs/users.json); do 
        response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
            -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" -d "$row" "${WEB_PAGE}/api/users")

        [ "$response" -ne 200 ] && echo -e "Failed to add user ($?) - $response\n$row" >&2 &&\
            sleep 2 && setup_users && return
    done

    # Add users to their Teams
    
    #echo "Test users.json output"
    #cat /configs/users.json
    #
    #response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
    #    -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
    #    -d "{ \"Username\":\"blunto\", \"Password\":\"${BLUNTO_PASSWORD}\", \"Role\":1 }" \
    #    "${WEB_PAGE}/api/users")

    #[ "$response" -ne 200 ] && echo "Failed to add users ($?) - $response" >&2 &&\
    #    sleep 2 && setup_users && return
    #
    ##touch /data/.install_completed
}

setup_teams()
{
    echo "Adding teams.."

    for row in $(jq -c '.[]' /configs/teams.json); do 
        response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
            -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" -d "$row" "${WEB_PAGE}/api/teams")

        [ "$response" -ne 200 ] && echo -e "Failed to add team ($?) - $response\n$row" >&2 &&\
            sleep 2 && setup_teams && return
    done

    # Grant team to their EndpointIDs
}

setup_resource_controls()
{
    echo "Adding resource controls.."

    #for row in $(jq -c '.[]' /configs/resource_controls.json); do 
    #    response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
    #        -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
    #        -d "$row" "${WEB_PAGE}/api/resource_controls")

    #    [ "$response" -ne 200 ] && echo -e "Failed to add resource_control ($?) - $response\n$row" >&2 &&\
    #        sleep 2 && setup_resource_controls && return
    #done
}

login_to_admin()
{
    echo "Logging into admin.."
    response=$(curl -ksLf -X POST -H "Content-Type: application/json" \
        -c "$c_loc" -b "$c_loc" \
        -d "{ \"Username\":\"admin\", \"Password\":\"${PORTAINER_ADMIN_PASSWORD}\" }" \
        "${WEB_PAGE}/api/auth")
    
    curl_err="$?"
    
    echo "$response" | jq -e .jwt 2> /dev/null > /dev/null
    jq_err="$?"
   
    # Check if failed or invalid JSON.
    if [ "$curl_err" -ne 0 ] || [ "$jq_err" -ne 0 ]; then
        echo "Failed to login to admin (curl - $curl_err, jq - $jq_err)" >&2 && sleep 1 && login_to_admin
    else
        jwt_token=$(echo "$response" | jq -r .jwt)
        jwt_token_snipped=$(echo "$jwt_token" | head -c 10)
     
        echo "Auth token retrieved - ${jwt_token_snipped}<snipped>"
       
        echo "Checking if token is valid.."
        response=$(curl -ksLf -X GET -H "Content-Type: application/json" \
            -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
            "${WEB_PAGE}/api/users/admin/check")
        
        [ "$response" -ne 204 ] && [ "$response" -ne 200 ] &&\
            echo "Failed to validate auth token ($?) - $response" >&2 && sleep 2 && login_to_admin && return

        echo "Auth token is valid!"
    fi
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
    
    [ "$response" -ne 200 ] && echo "Failed to set the admin password ($?) - $response" >&2 &&\
        sleep 1 && setup_admin && return || created_admin=1
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
    setup_resource_controls
    setup_teams
    setup_users
}

set_permissions()
{
    sleep 1
    chmod -R 760 /data/
}

set_permissions &

if [ ! -f /data/.install_completed ]; then
    start_install &
fi

exec /portainer $@
