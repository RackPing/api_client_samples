FROM ruby:2.5.5

# Program: Dockerfile
# Usage: see make.sh
# Date: 2020 11 17
# Purpose: build RackPing API Docker image with support for several scripting languages
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Notes:
# - fill in env.list config file first before doing `docker run`
# - based on a ruby debian/ubuntu image

MAINTAINER RackPing <support@rackping.com>

ENV RackPing API 2.0 Client Sample Programs Docker 1.0

WORKDIR /root

# See this link for TERM warnings: https://github.com/phusion/baseimage-docker/issues/58

RUN apt update && \
    apt install -y jq less lsof net-tools telnet vim \
                   php php-curl php-dev php-pear php-propro php-raphf \
                   python-pip python3-pip libwww-perl golang default-jdk && \
    apt clean && \
    apt autoremove --purge

RUN gem install httparty && \
    pip install requests urllib3 && \
    pip3 install requests urllib3 && \
    pecl install pecl_http && \
    cpan HTTP::Request


RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# ADD doesn't automatically unpack from remote URLs
ADD https://github.com/RackPing/api_client_samples/archive/main.zip .
RUN unzip main.zip
#RUN rm main.zip

WORKDIR /root/api_client_samples-main

COPY show_env.sh .

# we're using the docker cli env.list feature, so truncate the old settings in set.sh to make a generic image
RUN echo > set.sh && \
    ln -s /usr/bin/jq /usr/local/bin/jq && \
    mkdir -p /opt/rh/python27/root/usr/bin && \
    ln -s /usr/bin/python /opt/rh/python27/root/usr/bin/python

# configure php.ini extensions needed to run pecl_http
RUN for i in "raphf.so" "propro.so" "http.so" "curl.so" ; do echo "extension=$i" >> /etc/php/7.3/cli/php.ini; done

# debug statements
#RUN ./show_env.sh

CMD /bin/bash -c "time ./demo_all.sh"

