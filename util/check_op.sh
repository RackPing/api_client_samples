#!/bin/bash

# Program: check_op.sh
# Purpose: check for mismatched contact and check tokens
# Usage: ./check_op.sh
# Copyright: RackPing USA 2021
# Date: 2021 03 21
# Env: bash
# Note:

find .. -name 'rp_*contact*' -exec grep -H check {} \;
find .. -name 'rp_*check*' -exec grep -H contact {} \;

exit 0

