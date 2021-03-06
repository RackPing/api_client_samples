#!/bin/bash

# Program: rp_add_contact.sh
# Usage: ./rp_add_contact.sh
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

if [ "$debug" == "1" ]; then
   ENABLE_DEBUG="-d"
fi

pw=$(head -c 512 /dev/urandom | tr -dc 'a-zA-Z0-9!?.,-' | fold -w 10 | head -n 1)

json=$(cat <<EOF
{
   "first"       : "John",
   "last"        : "Doe",
   "email"       : "john.doe+$api_key@example.com",
   "role"        : "O",
   "cellphone"   : "408 555 1212",
   "countrycode" : 1,
   "countryiso"  : "US",
   "alertable"   : "N",
   "sendemail"   : "0",
   "password"    : "$pw"

}
EOF
)

#echo $json

options="--max-redirect=$redirects --quiet --timeout $timeout -O -"
auth_options="--auth-no-challenge --http-user $user --http-password $password"

echo "Add one contact:" >&2
wget $options $auth_options --header="App-key: $api_key" --header="Accept-Charset: utf-8" --header="Content-Type: application/json" --header="Accept: application/json" \
   $ENABLE_DEBUG --post-data="$json" ${url}/contacts

ret=$?

if [ "$debug" == "1" ]; then
   echo -e "\nret=$ret\n" >&2
fi

exit 0

