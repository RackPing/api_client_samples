#!/bin/bash

# Program: rp_pause_maint.sh
# Usage: ./rp_pause_maint.sh id
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

options="--max-redirect=$redirects --quiet --timeout $timeout -O -"
auth_options="--auth-no-challenge --http-user $user --http-password $password"

echo "Enable maintenance for one check:"
wget $options $auth_options --header='X-HTTP-Method-Override: PUT' --header="App-key: $api_key" --header="Accept-Charset: UTF-8" --header="Content-Type: application/json" ${url}/checks/$id?maintenance=1
ret=$?

if [ "$debug" == "1" ]; then
   echo -e "\nret=$ret\n"
fi

exit 0

