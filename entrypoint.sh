#!/bin/bash
set -e

BASE_DIR=${APP_DIR}
if [[ -z "${BASE_DIR}" ]]; then
    BASE_DIR="/app"
fi

if [[ -n "${BRIGHT_DATA_API_TOKEN}" && -n "${BRIGHT_DATA_USERNAME}" && -n "${BRIGHT_DATA_PASSWORD}" && -n "${BRIGHT_DATA_ZONE}" ]]; then
    BRIGHT_DATA_URL="https://api.brightdata.com/zone/route_ips?zone=$BRIGHT_DATA_ZONE"
    echo "Downloading proxy list from $BRIGHT_DATA_URL"
    curl -s -H "Authorization: Bearer $BRIGHT_DATA_API_TOKEN" "$BRIGHT_DATA_URL" > $BASE_DIR/proxy-list.txt
    echo "Correctly formatting proxy list file"
    # Builds the URL with the username, password and the endpoint of Bright Data
    SUBSTITUTION_PATTERN="s/^.*/http:\/\/${BRIGHT_DATA_USERNAME}-ip-&:${BRIGHT_DATA_PASSWORD}@brd.superproxy.io:22225/"
    sed -i $SUBSTITUTION_PATTERN $BASE_DIR/proxy-list.txt
    echo " ---> Done"
elif [[ -z "${PROXY_LIST_URL}" ]]; then
    echo "Using mounted proxy list"
    touch $BASE_DIR/proxy-list.txt
    echo " ---> Done"
else
    echo "Downloading proxy list from $PROXY_LIST_URL"
    curl -s $PROXY_LIST_URL > $BASE_DIR/proxy-list.txt
    echo " ---> Done"
fi

echo "Adding proxy list to config file"
# Remove blank lines
sed -i '/^$/d' $BASE_DIR/proxy-list.txt
# Prepend forward= in front of each line to match glider config syntax
sed -i 's/^/forward=/' $BASE_DIR/proxy-list.txt
# Randomize and append
cat $BASE_DIR/proxy-list.txt | shuf >> $BASE_DIR/glider.conf
echo " ---> Done"

echo "Using config file"
cat $BASE_DIR/glider.conf

echo ""
echo "Starting process"
exec "$@"
