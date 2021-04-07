#!/bin/bash

# Program: findmissing.sh
# Purpose: find a missing string in multiple files
# Usage: ./check_op.sh
# Copyright: RackPing USA 2021
# Date: 2021 03 21
# Env: bash
# Note: 

find .. -name 'rp_*' -exec grep -i -L $1 {} \;

exit 0
