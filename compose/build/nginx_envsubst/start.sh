#!/bin/sh 
file="$1"
echo "Processing $file"

if [[ ! -z "$file" ]]; then  
    [[ ! -f "$file" ]] && exit 0
    
    envsubst "`printf '${%s} ' $(printenv | cut -d "=" -f 1)`" \
        < "$file" > "/mnt/output/$(basename \"$file \")"
else
    find /mnt/input -type f -name "*.conf" -exec /start.sh {} \;
fi

