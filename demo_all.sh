#!/bin/bash

# Program: demo_all.sh
# Usage: ./demo_all.sh
# Date: 2020 10 05
# Purpose: run test harnesses named demo.sh in all subdirectories
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note: uncomment the set -e line if you want to stop the test harness immediately when a language folder has a non-zero exit

#set -e

date

for i in *; do
   if [ -d $i ]; then
      if [ -r "$i/demo.sh" ]; then
         cat <<EOD

***
*** Language: $i
***

EOD

         (cd $i && time ./demo.sh)
      fi
   fi
done

date

echo 

set +e

exit 0
