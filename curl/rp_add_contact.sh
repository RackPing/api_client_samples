#!/bin/bash

# Program: rp_add_contact.sh
# Usage: ./rp_add_contact.sh contactid
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

options="-sS --max-redirs $redirects --max-time $timeout"
auth_options="--basic -u $user:$password"

echo "Add one contact using HERE document:" >&2
curl $options $auth_options -H 'Content-type: application/json' -H 'Accept: application/json' -H 'Accept-Charset: utf-8' -H "App-key: $RP_API_KEY" -w "\n" -X POST --data-binary @- ${url}/contacts <<EOF
{
   "first"        : "John",
   "last"         : "Doe",
   "email"        : "john.doe+$api_key@example.com",
   "role"         : "O",
   "cellphone"    : "408 555 1212",
   "countrycode"  : 1,
   "countryiso"   : "US"
}
EOF

ret=$?
echo -e "ret=$ret\n" >&2

set +e

exit 0

