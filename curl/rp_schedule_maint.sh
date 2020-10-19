#!/bin/bash

# Program: rp_schedule_maint.sh
# Usage:  ./rp_schedule_maint.sh checkid "start" "end"
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

if [ $# -ne 3 ]; then
   echo "usage: $0 id 'start' 'end'"
   exit 1
fi

id=$1
start=`echo "$2" | sed 's/ /%20/'`
end=`echo "$3" | sed 's/ /%20/'`

options="-sS --max-redirs $redirects --max-time $timeout"
auth_options="--basic -u $user:$password"

echo "Enable maintenance window for one check:"
curl $options $auth_options -H "App-key: $RP_API_KEY" -X PUT "${url}/checks/$id?start_maintenance=$start&end_maintenance=$end" -w "\n"
ret=$?
echo -e "ret=$ret\n"

set +e

exit 0

