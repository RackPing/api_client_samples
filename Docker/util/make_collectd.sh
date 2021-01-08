#!/bin/bash

# Program: make_collectd.sh
# Usage: sudo ./make_collectd.sh
# Date: 2020 12 20
# Purpose: install collectd and optionally collectd-web on a client host
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note: these packages have several dependencies
#       See https://www.tecmint.com/install-collectd-and-collectd-web-to-monitor-server-resources-in-linux/

### start of user settings

# For a client host, the next hop, which is blank for the rackping listener. For a proxy, the IP address of the proxy host itself.
target_server=""

# For a client host, "N". For a proxy, "Y"
is_proxy="N"

# For testing, install the collectd-web CGI program to view graphs (optional)
install_collectd_web="N"

### end of user settings

rackping_server="72.9.103.50"

if [[ "$target_server" == "" ]]; then
   $target_server="$rackping_server"
fi

apt install -y collectd rsyslog

if [[ "$is_proxy" == "N" ]]; then
   cat >>/etc/collectd/collectd.conf <<EOD
# Send metrics directly from this host or container to RackPing:
LoadPlugin network
<Plugin network>
   Server "$rackping_server"
</Plugin>
EOD
else
   cat >>/etc/collectd/collectd.conf <<EOD
# Proxy from this host on your network to RackPing:
LoadPlugin network
<Plugin network>
  Listen "$target_server"
  Server "$rackping_server"
  Forward true
</Plugin>
EOD
fi

for i in rsyslog collectd; do
   service $i start
   systemctl enable $i
done

# install collectd-web (optional)
if [[ "$install_collectd_web" == "Y" ]]; then
   apt install -y git librrds-perl libjson-perl libhtml-parser-perl
   cd /usr/local/
   git clone https://github.com/httpdss/collectd-web.git
   cd collectd-web/
   chmod +x cgi-bin/graphdefs.cgi
   echo "update host from 127.0.0.1 to 0.0.0.0 (or hostname) in runserver.py if necessary:"
   echo $HOSTNAME
   read
   vi runserver.py
   python runserver.py &
   netstat -an | grep :8888
   echo "info: add iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 8888 -j ACCEPT"
   echo "info: add an httpd block for /usr/local/collectd-web /cgi-bin"
   echo <<EOD
<Directory /usr/local/collectd-web/cgi-bin>
Options Indexes ExecCGI
AllowOverride All
AddHandler cgi-script .cgi
Require all granted
</Directory>
EOD

fi

# show collectd version
collectd -h

# show if collectd is running
netstat -an | grep :8888

exit
