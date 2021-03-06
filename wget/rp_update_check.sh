#!/bin/bash

# Program: rp_update_check.sh
# Usage: ./rp_update_check.sh id
# Date: 2020 10 05
# Purpose: wget language sample client program for RackPing Monitoring API 2.0
# Version: 1.0
# Env: bash/wget
# Copyright: RackPing USA 2016
# Note: curl is recommended instead of wget for programming. These wget sample programs are provided in case you cannot install curl.

source ../set.sh

scheme=$RP_SCHEME
domain=$RP_DOMAIN
base_url=$RP_BASE_URL
api_key=$RP_API_KEY
user=$RP_USER
password=$RP_PASSWORD
timeout=$RP_TIMEOUT
redirects=$RP_REDIRECTS
debug=$RP_DEBUG

url="${scheme}${domain}${base_url}"

if [ "$url" == "" ]; then
   echo "do source ../set.sh"
   exit 1
fi

id="$1"

if [ "$id" == "" ]; then
   echo "usage: $0 id"
   exit 1
fi

if [ "$debug" == "1" ]; then
   ENABLE_DEBUG="-d"
fi

options="--max-redirect=$redirects --quiet --timeout $timeout -O -"
auth_options="--auth-no-challenge --http-user $user --http-password $password"

json=$(cat <<EOF
{
   "name"       : "APITestTest",
   "host"       : "https://www.rackping.com/?$api_key",
   "port"       : 443,
   "resolution" : 60,
   "paused"     : 1
}
EOF
)

#echo $json

echo "Update one check:"
wget $options $auth_options --header='X-HTTP-Method-Override: PUT' --header="App-key: $api_key" --header="Accept-Charset: utf-8" --header="Content-Type: application/json" --header="Accept: application/json" \
   $ENABLE_DEBUG --post-data="$json" ${url}/checks/$id
ret=$?

if [ "$debug" == "1" ]; then
   echo -e "\nret=$ret\n"
fi

exit 0

