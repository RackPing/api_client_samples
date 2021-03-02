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
mylang="rs"

distro="dist/bin"

n_progs=`ls -1 $distro | grep -c rp_`
if [[ "$n_progs" < 13 ]]; then
   echo "error: run rust/build.sh first (takes about 1 hour)"
   exit 1
fi

source ../set.sh

re='^[0-9]+$'

echo "0. Cleanup old demo contacts and checks:"

old_id=`$distro/rp_list_contacts | jq '.contacts[] | select(.last=="Doe") | .id'`
if [[ $old_id =~ $re ]] ; then
   $distro/rp_del_contact $old_id
fi

# support versions of jq before 1.5, which don't have startswith()
old_id=`$distro/rp_list_checks | jq '.checks[] | select(.name=="APITest" or .name=="APITestTest") | .id'`
if [[ $old_id =~ $re ]] ; then
   $distro/rp_del_check $old_id
fi

# 1. Demo the contacts (users) scripts

$distro/rp_list_contacts

# edit rp_add_contact to set the contact (user) info
id=`$distro/rp_add_contact | $jq_cmd '.contact .id'`

if ! [[ $id =~ $re ]] ; then
   echo "error: unable to parse response for a new numeric contact id. Please login manually, remove the old test contact, and try again." >&2
   echo 
   exit 1
fi

echo "info: new contact id $id"

$distro/rp_update_contact $id

$distro/rp_del_contact $id

$distro/rp_list_contacts

# 2. Demo the checks (monitors) scripts

$distro/rp_list_checks

# edit rp_add_check to set the check (monitor) info
id=`$distro/rp_add_check | $jq_cmd '.checks .id'`

if ! [[ $id =~ $re ]] ; then
   echo "error: unable to parse response for a new numeric check id. Please login manually, remove the old test check, and try again." >&2
   echo 
   exit 1
fi

echo "info: new check id $id"

$distro/rp_update_check $id

$distro/rp_pause_check $id
$distro/rp_resume_check $id

$distro/rp_pause_maint $id
$distro/rp_resume_maint $id

$distro/rp_schedule_maint $id "2020-10-01 00:00:10" "2020-10-07 00:00:00"

$distro/rp_del_check $id

$distro/rp_list_checks

echo
echo "info: if there's any failed steps above, login to your RackPing account and manually delete any test contacts or checks, then try again."

exit 0

