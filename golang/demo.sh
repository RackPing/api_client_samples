#!/bin/bash

# Program: demo.sh
# Usage: ./demo.sh
# Date: 2020 10 05
# Purpose: demo/test harness for the RackPing Monitoring API sample client programs
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Notes:
# - this script will use your RackPing account to list, add and delete sample records
# - requires installation of jq

# use the jq Command-line JSON processor to extract new id's
jq_cmd="/usr/bin/jq"

# set the language extension for this sample folder
mylang="go"

source ../set.sh

re='^[0-9]+$'

# 0. Cleanup old demo contacts and checks

old_id=`./rp_list_contacts.$mylang | jq '.contacts[] | select(.last=="Doe") | .id'`
if [[ $old_id =~ $re ]] ; then
   ./rp_del_contact.$mylang $old_id
fi

# support versions of jq before 1.5, which don't have startswith()
old_id=`./rp_list_checks.$mylang | jq '.checks[] | select(.name=="APITest") | .id'`
if [[ $old_id =~ $re ]] ; then
   ./rp_del_check.$mylang $old_id
fi

if [ -z "$old_id" ]; then
   old_id=`./rp_list_checks.$mylang | jq '.checks[] | select(.name=="APITestTest") | .id'`
   if [[ $old_id =~ $re ]] ; then
      ./rp_del_check.$mylang $old_id
   fi
fi

# 1. Demo the contacts (users) scripts

./rp_list_contacts.$mylang

# edit rp_add_contact.$mylang to set the contact (user) info
id=`./rp_add_contact.$mylang | $jq_cmd '.contact .id'`

if ! [[ $id =~ $re ]] ; then
   echo "error: unable to parse response for a new numeric contact id. Please login manually, remove the old test contact, and try again." >&2
   echo 
   exit 1
fi

echo "info: new contact id $id"

./rp_update_contact.$mylang $id

./rp_del_contact.$mylang $id

./rp_list_contacts.$mylang

# 2. Demo the checks (monitors) scripts

./rp_list_checks.$mylang

# edit rp_add_check.$mylang to set the check (monitor) info
id=`./rp_add_check.$mylang | $jq_cmd '.checks .id'`

if ! [[ $id =~ $re ]] ; then
   echo "error: unable to parse response for a new numeric check id. Please login manually, remove the old test check, and try again." >&2
   echo 
   exit 1
fi

echo "info: new check id $id"

./rp_update_check.$mylang $id

./rp_pause_check.$mylang $id
./rp_resume_check.$mylang $id

./rp_pause_maint.$mylang $id
./rp_resume_maint.$mylang $id
./rp_schedule_maint.$mylang $id "2020-10-01 00:00:00" "2020-10-07 00:00:00"

./rp_del_check.$mylang $id

./rp_list_checks.$mylang

echo
echo "info: if there's any failed steps above, login to your RackPing account and manually delete any test contacts or checks, then try again."

exit 0

