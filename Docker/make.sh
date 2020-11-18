#!/bin/bash

# Program: make.sh
# Usage: ./make.sh
# Date: 2020 11 17
# Purpose: build RackPing API Docker image
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note: fill in env.list config file first before running the image

# takes 5-10 minutes to build with a fast Internet connection
sudo docker build -t rackping_api:latest .
docker images

# takes 1 minute to run the test harness
docker run --env-file ./env.list rackping_api /bin/bash -c "time ./demo_all.sh"

# helpful debugging commands:
#
# docker run --env-file ./env.list rackping_api sleep 1800 &
# docker ps
# docker exec -it 1b4bf7e6bb63 /bin/bash
# docker exec -it 1b4bf7e6bb63 /bin/bash -c "cd perl; time ./demo.sh"
