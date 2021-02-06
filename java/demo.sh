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
mylang="java"

source ../set.sh

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.265.b01-0.el6_10.x86_64
export PATH=$JAVA_HOME/bin:$PATH

opt="-cp .:json-simple-1.1.1.jar"
java="/usr/bin/java -client $opt "

re='^[0-9]+$'

if [[ ! -f "RackpingAddCheck.class" ]]; then
   ./build.sh
fi

echo "0. Cleanup old demo contacts and checks:"

old_id=`$java RackpingListContacts | jq '.contacts[] | select(.last=="Doe") | .id'`
if [[ $old_id =~ $re ]] ; then
   $java RackpingDelContact $old_id
fi

# support versions of jq before 1.5, which don't have startswith()
old_id=`$java RackpingListChecks | jq '.checks[] | select(.name=="APITest" or .name=="APITestTest") | .id'`
if [[ $old_id =~ $re ]] ; then
   $java RackpingDelCheck $old_id
fi

# 1. Demo the contacts (users) scripts

$java RackpingListContacts

# edit RackpingAddContact.java to set the contact (user) info
id=`$java RackpingAddContact | $jq_cmd '.contact .id'`
echo "info: new contact id $id"

if ! [[ $id =~ $re ]] ; then
   echo "error: unable to parse response for a new numeric contact id. Please login manually, remove the old test contact, and try again." >&2
   echo 
   exit 1
fi

$java RackpingUpdateContact $id

$java RackpingDelContact $id

$java RackpingListContacts

# 2. Demo the checks (monitors) scripts

$java RackpingListChecks

# edit RackpingAddCheck.java to set the check (monitor) info
id=`$java RackpingAddCheck | $jq_cmd '.checks .id'`

if ! [[ $id =~ $re ]] ; then
   echo "error: unable to parse response for a new numeric check id. Please login manually, remove the old test check, and try again." >&2
   echo  
   exit 1
fi

echo "info: new check id $id"

$java RackpingPauseCheck $id
$java RackpingResumeCheck $id

$java RackpingPauseMaint $id
$java RackpingResumeMaint $id
$java RackpingScheduleMaint $id "2020-10-01 00:00:00" "2020-10-07 00:00:00"

$java RackpingDelCheck $id

$java RackpingListChecks

echo
echo "info: if there's any failed steps above, login to your RackPing account and manually delete any test contacts or checks, then try again."

exit 0

