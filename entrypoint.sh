#!/bin/bash
set -e

if [[ -z "${PROXY_LIST_URL}" ]]; then
    echo "Using mounted proxy list"
    touch /app/proxy-list.txt
    echo " ---> Done"
else
    echo "Downloading proxy list from $PROXY_LIST_URL"
    curl -s $PROXY_LIST_URL > /app/proxy-list.txt
    echo " ---> Done"
fi

echo "Adding proy list to config file"
# Remove blank lines
sed -i '/^$/d' /app/proxy-list.txt
# Prepend forward= in front of each line to match glider config syntax
sed -i 's/^/forward=/' /app/proxy-list.txt
# Randomize and happen 
cat /app/proxy-list.txt | shuf >> /app/glider.conf
echo " ---> Done"

echo "Using config file"
cat /app/glider.conf

echo ""
echo "Starting process"
exec "$@"