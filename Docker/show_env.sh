#!/bin/bash

# Program: show_env.sh
# Usage: ./show_env.sh
# Date: 2020 11 17
# Purpose: helper file used in debugging docker container during run
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note: fill in env.list config file first before running

# show envariables

set

# other diagnostic commands

ls -l
tail /etc/php/7.3/cli/php.ini
