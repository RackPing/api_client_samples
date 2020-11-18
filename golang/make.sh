#!/bin/bash

# Program: make.sh
# Usage: ./make.sh
# Date: 2020 10 05
# Purpose: set permissions and check the syntax of RackPing API sample client programs
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note:

mylang=go

for i in *.$mylang; do
    chmod 755 $i
    gofmt -e $i > /dev/null
done

for i in *.sh; do
    echo $i
    chmod 755 $i
done

# golangci-lint - ignore "redeclared in this block" errors because each file is standalone, and not part of a go project
# golangci-lint run .

exit 0
