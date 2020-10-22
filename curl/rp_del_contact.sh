#!/bin/bash

# Program: rp_del_contact.sh
# Usage: ./rp_del_contact.sh contactid
# Purpose: curl sample client program for RackPing Monitoring API 2.0
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Returns: exit status is non-zero on failure
# Note: First set the envariables with: source ../set.sh

set -e

#source ../set.sh

api_key=$RP_API_KEY
user=$RP_USER
password=$RP_PASSWORD
scheme=$RP_SCHEME
domain=$RP_DOMAIN
base_url=$RP_BASE_URL
timeout=$RP_TIMEOUT
redirects=$RP_REDIRECTS
debug=$RP_DEBUG

url="${scheme}${domain}${base_url}"

if [ "$url" == "" ]; then
   echo "error: do ../set.sh"
   exit 1
fi

id=$1

if [ "$id" == "" ]; then
   echo "usage: $0 id"
   exit 1
fi

options="-sS --max-redirs $redirects --max-time $timeout"
auth_options="--basic -u $user:$password"

echo "Delete one contact"
#rc=`curl $options -I -w "%{http_code}" $auth_options -H "App-key: $RP_API_KEY" -X DELETE $url/contacts/$id`
rc=`curl $options $auth_options -H 'Accept: application/json' -H "App-key: $RP_API_KEY" -X DELETE $url/contacts/$id`
ret=$?
echo "rc=$rc"
echo -e "ret=$ret\n"

set +e

exit 0

