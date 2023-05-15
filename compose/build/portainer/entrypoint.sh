#!/bin/sh
chown -R root:${DATA_GID} /data/
chmod 755 /data

c_loc=/data/.install_cookie
jwt_token=
teams=

start_install()
{
    echo "Install started, waiting for Portainer to start.."
        
    # Wait until Portainer is started and accessible
    while [ ! $(pidof /portainer) ] || [ $(curl -Ikf -o /dev/null -w "%{http_code}\n" "${WEB_PAGE}/") -ne 200 ]; do
        sleep 2
    done

    # It has started, install code below
    get_team_id_from_team_name()
    {
        team_name="$1"
        echo "$teams" | jq -r ".[] | select(.Name == \"$team_name\") | .Id"
    }

    setup_users()
    {
        echo "Adding users.."

        add_user_to_team()
        {
            user_id="$1"
            team_id="$2"
            
            response=$(curl -ksLf -X POST -H "Content-Type: application/json" \
                -H "Authorization: Bearer ${jwt_token}" \
                -c "$c_loc" -b "$c_loc" \
                -d "{ \"UserID\":$user_id,\"TeamID\":$team_id,\"Role\":2 }" \
                "${WEB_PAGE}/api/team_memberships")
          
            teammembership_id=$(echo "$response" | jq -r '.Id')
            [ -z "$teammembership_id" ] || [ "$teammembership_id" = null ] &&\
                echo "Failed to add user ($user_id) to team ($team_id) - $?. Response: $response" &&\
                sleep 2 && add_user_to_team "$1" "$2"
            
            echo "Successfully added user ($user_id) to team ($team_id). (TeamMembership ID: $teammembership_id)"
        }
        
        for row in $(jq -c '.[]' /configs/users.json); do 
            response=$(curl -ksLf -X POST -H "Content-Type: application/json" \
                -H "Authorization: Bearer ${jwt_token}" \
                -c "$c_loc" -b "$c_loc" -d "$row" \
                "${WEB_PAGE}/api/users")

            user_id=$(echo "$response" | jq -r .Id)
           
            # Hide the password, we don't want sensitive info ending up in the docker logs
            row=$(echo "$row" | sed -E "s/\"Password\":\"[^\"]+\"/\"Password\":\"[Redacted]\"/")
            
            [ -z "$user_id" ] && echo -e "Failed to add user ($?)\n$row" >&2 &&\
                sleep 2 && setup_users && return
           
            echo "Added user, ID: $user_id"
        
            user_teams=$(echo "$row" | jq -r '.Teams')
            if [ "$user_teams" != "null" ]; then 
                for team_name in $(echo "$user_teams" | jq -r '.[]'); do 
                    echo "Getting ${team_name}'s ID.."
                    team_id=$(get_team_id_from_team_name "$team_name")
                    echo "Team ID successfully retrieved: $team_id"
                    echo "Adding user to the team.."
                    add_user_to_team "$user_id" "$team_id"
                    sleep 1
                done
            fi 
            
            sleep 1
        done
    }

    setup_teams()
    {
        echo "Adding teams.."
        for row in $(jq -c '.[]' /configs/teams.json); do 
            response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
                -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" -d "$row" "${WEB_PAGE}/api/teams")

            [ "$response" -ne 200 ] && [ "$response" -ne 409 ] && echo -e "Failed to add team ($?) - $response\n$row" >&2 &&\
                sleep 2 && setup_teams && return
        
            sleep 1
        done

        echo "Retrieving team list.."
        response=$(curl -ksLf -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
            -c "$c_loc" -b "$c_loc" "${WEB_PAGE}/api/teams")
        
        teams="$response"
        echo "Successfully retrieved teams: $response"
        
        echo "Giving teams access to their endpoints.."
        for row in $(jq -c '.[]' /configs/teams.json); do 
            team_name=$(echo "$row" | jq -r .Name)
            [ "$team_name" = null ] && continue
            
            team_id=$(get_team_id_from_team_name "$team_name")
            
            # endpoint ID 1 is in EndpointIDs by default because that's the primary / local one.
            for endpoint_id in $(echo "$row" | jq -r '.EndpointIDs | .[1:1] |= [1]'); do 
                echo "So we'd add the endpoint ID: $endpoint_id to Team ID: $team_id"
            
                #/endpoints/{id}
                #  endpoints.endpointUpdatePayload

                #endpoints.endpointUpdatePayload:
                #    properties:
                #      teamAccessPolicies:
                #        $ref: '#/definitions/portainer.TeamAccessPolicies'
                #      userAccessPolicies:
                #        $ref: '#/definitions/portainer.UserAccessPolicies'
                #    type: object
                   
                #portainer.TeamAccessPolicies:
                #  additionalProperties:
                #    $ref: '#/definitions/portainer.AccessPolicy'
                #  type: object
               
                #portainer.UserAccessPolicies:
                #   additionalProperties:
                #    $ref: '#/definitions/portainer.AccessPolicy'
                #   type: object
                
                #portainer.AccessPolicy:
                #    properties:
                #      RoleId:
                #        description: Role identifier. Reference the role that will be associated to
                #          this access policy
                #        example: 1
                #        type: integer
                #    type: object

                response=$(curl -ksLf -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
                    -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
                    -d "{ \"TeamAccessPolicies\": { \"$team_id\": { \"RoleID\": 0 } } }" \
                    "${WEB_PAGE}/api/endpoints/${endpoint_id}")
            
                [ "$response" -ne 200 ] && echo -e "Failed to give team ${team_name} (${team_id}) access to endpoint (${endpoint_id}) ($?) - $response\n$row" >&2 &&\
                    sleep 2 && setup_teams && return
            done
        done
    }

    #setup_resource_controls()
    #{
    #    echo "Adding resource controls.."
    #
    #    #for row in $(jq -c '.[]' /configs/resource_controls.json); do 
    #    #    response=$(curl -ksLf -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${jwt_token}" \
    #    #        -o /dev/null -w "%{http_code}\n" -c "$c_loc" -b "$c_loc" \
    #    #        -d "$row" "${WEB_PAGE}/api/resource_controls")
    #
    #    #    [ "$response" -ne 200 ] && echo -e "Failed to add resource_control ($?) - $response\n$row" >&2 &&\
    #    #        sleep 2 && setup_resource_controls && return
    #    #done
    #}

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
    
    setup_admin
    login_to_admin
    setup_teams
    setup_users

    ##touch /data/.install_completed
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
