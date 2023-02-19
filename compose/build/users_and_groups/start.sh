#!/bin/sh
for f in passwd group shadow env; do 
    echo '' > "/mnt/$f"
    chown root:root "/mnt/$f"
done

chmod 644 /mnt/passwd /mnt/group /mnt/env
chmod 640 /mnt/shadow

# Parse settings to add the desired users and groups
if [[ ! -f "/mnt/settings.yml" ]]; then 
    echo "Configuration /mnt/settings.yml is missing!"
    exit 1
fi  

settings=$(cat /mnt/settings.yml | envsubst)
groups=$(echo "$settings" | yq ".groups | keys | .[]")
users=$(echo "$settings" | yq ".users | keys | .[]")

for group in "$groups"; do
    #echo "$group"
    id=$(echo "$groups" | yq ".$group.id")
    echo "Test id $id"
done

for user in "$users"; do    
    #echo "$user"
    groups=$(echo "$users" | yq ".$user.groups | keys | .[]")
    #echo "$groups"
done

# Now that we've added all the users and groups, we will 
# output our user files into /mnt, which other 
# containers can have mounted to them as READ-ONLY.
for f in passwd group shadow; do
    getent "$f" > "/mnt/$f"
done

# We will export the users and their ids to an env file which can
# be used in a docker-compose --env-file to make it possible
# to use user and group names created by the container instead of ids
getent passwd | while IFS=: read -r user _ uid gid _; do 
    printf '%s_u=%i\n%s_g=%i\n' "$user" "$uid" "$user" "$gid" >> /mnt/env 2>&1 >&1
done
