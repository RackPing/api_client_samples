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
# - requires Perl CPAN module HTTP::Request::Common 6.07+ (can be checked with perldoc -m HTTP::Request::Common)

# use the jq Command-line JSON processor to extract new id's
jq_cmd="/usr/bin/jq"

# set the language extension for this sample folder
mylang="java"

source ../set.sh

set -o pipefail
set -e

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.265.b01-0.el6_10.x86_64
export PATH=$JAVA_HOME/bin:$PATH

java="/usr/bin/java -client"
opt="-cp .:json-simple-1.1.1.jar"

for f in *.java; do
   class=`basename $f .java`
   echo $class
   $java $opt $class
done

echo
echo "info: if there's any failed steps above, login to your RackPing account and manually delete any test contacts or checks, then try again."

exit 0
