#!/bin/bash
set -e

BASE_DIR=${APP_DIR}
if [[ -z "${BASE_DIR}" ]]; then
    BASE_DIR="/app"
fi

if [[ -z "${PROXY_LIST_URL}" ]]; then
    echo "Using mounted proxy list"
    touch $BASE_DIR/proxy-list.txt
    echo " ---> Done"
else
    echo "Downloading proxy list from $PROXY_LIST_URL"
    curl -s $PROXY_LIST_URL > $BASE_DIR/proxy-list.txt
    echo " ---> Done"
fi

echo "Adding proy list to config file"
# Remove blank lines
sed -i '/^$/d' $BASE_DIR/proxy-list.txt
# Prepend forward= in front of each line to match glider config syntax
sed -i 's/^/forward=/' $BASE_DIR/proxy-list.txt
# Randomize and happen 
cat $BASE_DIR/proxy-list.txt | shuf >> $BASE_DIR/glider.conf
echo " ---> Done"

echo "Using config file"
cat $BASE_DIR/glider.conf

echo ""
echo "Starting process"
exec "$@"
