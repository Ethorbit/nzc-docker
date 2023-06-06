#!/bin/sh
check_changes() {
    echo "Nginx will auto-reload when a config or certificate changes."
    
    inotifywait -m -r \
        -e create,modify,delete,move \
        --exclude '.*(template).*' \
        /etc/nginx/snippets/ \
        /etc/nginx/conf.d/ \
        ${NGINX_SSL_DHPARAM} \
        ${NGINX_SSL_CERT} \
        ${NGINX_SSL_CERT_KEY} | while read dir action file; do
            echo "File in $dir changed ($action) - $file, reloading.."
            nginx -t && nginx -s reload
        done

    check_changes # It should never stop.
}

check_changes &
