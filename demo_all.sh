#!/bin/bash

# Program: demo_all.sh
# Usage: ./demo_all.sh
# Date: 2020 10 05
# Purpose: run test harnesses named demo.sh in all subdirectories
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note:

date

for i in *; do
   if [ -d $i ]; then
      if [ -r "$i/demo.sh" ]; then
         echo
         echo "***"
         echo "*** $i"
         echo "***"
         echo

         cd $i
         time ./demo.sh
         cd -
      fi
   fi
done

date

echo 

exit 0
