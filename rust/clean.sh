#!/bin/bash

# Program: clean.sh
# Usage: ./clean.sh
# Date: 2021 02 10
# Purpose: remove items that should not be retained or committed after building and testing
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note:

for i in target Cargo.lock; do
   find . -name $i -exec rm -fr {} \;
done

exit 0

