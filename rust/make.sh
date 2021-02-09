#!/bin/bash

# Program: make.sh
# Usage: ./make.sh
# Date: 2020 10 05
# Purpose: set permissions and check the syntax of RackPing API sample client programs
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note:

mylang=rs

for i in *.$mylang; do
    echo $i
    rustc $i > /dev/null
done

# find files with no file extension and update permissions
find . -type f ! -name "*.*" -exec chmod 755 {} \;

for i in *.sh; do
    echo $i
    chmod 755 $i
done

exit 0