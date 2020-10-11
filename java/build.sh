#!/bin/bash

# Program: build.sh
# Purpose: build Java RackPing Sample API Programs
# Usage: ./build.sh
# Copyright: RackPing USA 2020
# Env: bash
# Returns: exit status is non-zero on failure
# Note:
# To install java on CentOS 6:
#    sudo yum install java-1.8.0-openjdk
#    sudo yum install java-1.8.0-openjdk-devel
#    wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/json-simple/json-simple-1.1.1.jar

source ../set.sh

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.265.b01-0.el6_10.x86_64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH="."

java="/usr/bin/java -client"
#javac="/usr/bin/javac -g:none -Xlint:all"
javac="/usr/bin/javac -Xlint:all -cp *:."
opt="-cp .:json-simple-1.1.1.jar"

for i in RackPingChecks RackPingContacts; do
   class=$i
   rm -f $class.class
   $javac $opt $class.java
   $java $opt $class
done

exit 0
