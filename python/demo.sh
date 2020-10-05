#!/bin/bash

# Program: demo.sh
# Usage: ./demo.sh
# Purpose: demo/test harness for the RackPing Monitoring API sample client programs
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Notes:
# - this script will use your RackPing account to list, add and delete sample records
# - requires installation of jq
# - requires python 2.7.9+ and urllib3

# use the jq Command-line JSON processor to extract new id's
jq_cmd="/usr/bin/jq"

# set the language extension for this sample folder
mylang="py"

cmd_python="/opt/rh/python27/root/usr/bin/python"

source ../set.sh

# 1. Demo the contacts (users) scripts

$cmd_python ./rp_list_contacts.$mylang

# edit add_contact.$mylang to set the contact (user) info
id=`$cmd_python ./rp_add_contact.$mylang | $jq_cmd '.contact .id'`
echo "info: new contact id $id"

$cmd_python ./rp_update_contact.$mylang $id

$cmd_python ./rp_del_contact.$mylang $id

$cmd_python ./rp_list_contacts.$mylang

# 2. Demo the checks (monitors) scripts

$cmd_python ./rp_list_checks.$mylang

# edit add_check.$mylang to set the check (monitor) info
id=`$cmd_python ./rp_add_check.$mylang | $jq_cmd '.checks[0] .id'`
echo "info: new check id $id"

$cmd_python ./rp_pause_check.$mylang $id
$cmd_python ./rp_resume_check.$mylang $id

$cmd_python ./rp_pause_maint.$mylang $id
$cmd_python ./rp_resume_maint.$mylang $id

$cmd_python ./rp_del_check.$mylang $id

$cmd_python ./rp_list_checks.$mylang

exit 0

