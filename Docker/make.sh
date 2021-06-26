#!/bin/bash

# Program: make.sh
# Usage: ./make.sh
# Date: 2020 11 17
# Purpose: build RackPing API Docker image
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note: fill in env.list config file first before running the image

printenv

# takes 5-10 minutes to build with a fast Internet connection
sudo docker build -t rackping_api:latest .
docker images

# takes 1 minute to run the test harness, then terminate and remove the container process:
docker run --privileged --rm --env-file ./env.list rackping_api

# helpful debugging commands:
#
# start a persistent process for 30 minutes in the background, then remove process:
# docker run --privileged --rm -d --env-file ./env.list rackping_api sleep 1800 &
# find the container process id in the first column:
# docker ps
#
# login to the container and run the test harness one or more times:
# docker exec -it <CONTAINER_ID> /bin/bash
# time ./demo_all.sh
#
# use the persistent container to run tests for one scripting language:
# docker exec -it <CONTAINER_ID> /bin/bash -c "cd perl; time ./demo.sh"
