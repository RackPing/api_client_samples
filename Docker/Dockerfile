FROM ruby:2.5.5

# Program: Dockerfile
# Usage: see make.sh
# Date: 2020 11 17
# Purpose: build RackPing API Docker image with support for several scripting languages
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Notes:
#
# - fill in env.list config file first before running the image
# - based on a ruby debian/ubuntu image

RUN apt update && \
  apt install -y jq python-pip python3-pip php php-dev php-pear php-raphf php-propro php-curl libwww-perl golang default-jdk

# need to install java here if necessary

RUN gem install httparty

RUN pip install requests urllib3

RUN pip3 install requests urllib3

RUN pecl install pecl_http

RUN cpan HTTP::Request

RUN mkdir -p root
RUN cd root
WORKDIR /root

ADD https://github.com/RackPing/api_client_samples/archive/main.zip .
RUN unzip main.zip
#RUN rm main.zip

RUN cd api_client_samples-main
WORKDIR /root/api_client_samples-main

# we're using the docker cli feature to make a generic image, so truncate the old settings
RUN echo > set.sh

COPY show_env.sh .
RUN chmod 755 show_env.sh 

RUN ln -s /usr/bin/jq /usr/local/bin/jq

# minor workaround for non-portable API sample config
RUN mkdir -p /opt/rh/python27/root/usr/bin
RUN ln -s /usr/bin/python /opt/rh/python27/root/usr/bin/python

RUN echo "extension=raphf.so"  >> /etc/php/7.3/cli/php.ini
RUN echo "extension=propro.so" >> /etc/php/7.3/cli/php.ini
RUN echo "extension=http.so"   >> /etc/php/7.3/cli/php.ini
RUN echo "extension=http.so"   >> /etc/php/7.3/cli/php.ini
RUN echo "extension=curl.so"   >> /etc/php/7.3/cli/php.ini

# debug statements
#RUN ./show_env.sh 
#RUN ls -l

CMD /bin/bash -c "time ./demo_all.sh"

