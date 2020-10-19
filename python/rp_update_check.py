#!/usr/bin/python

'''This is a python sample client program for the RackPing Monitoring API 2.0.'''

# Program: rp_update_check.py
# Usage: ./rp_update_check.py id
# Version: 1.0
# Env: Python 2.7.9 or newer with urllib3
# Returns: exit status is non-zero on failure
# Copyright: RackPing USA 2020
# Note: For Centos6 python 2.7.9, do:
#   yum install python-pip
#   pip install requests
#   pip install urllib3
#   source ../set.sh

import json
import os
import sys
# https://urllib3.readthedocs.io/en/latest/advanced-usage.html#ssl-warnings
#import urllib3
#urllib3.disable_warnings()
import requests
from requests.auth import HTTPBasicAuth
from pprint import pprint

try:
   scheme   = os.environ['RP_SCHEME']
   domain   = os.environ['RP_DOMAIN']
   base_url = os.environ['RP_BASE_URL']
   timeout  = float(os.environ['RP_TIMEOUT'])
   api_key  = os.environ['RP_API_KEY']
   user     = os.environ['RP_USER']
   password = os.environ['RP_PASSWORD']
except KeyError as e:
   sys.exit('error: env not set. Please do source ../set.sh and try again: First missing key ' + e.args[0])

url = scheme + domain + base_url

if len(sys.argv) < 2:
   sys.exit('usage: ' + sys.argv[0] + ' id')

### start of user settings

debug = 0

checkid    = sys.argv[1];

form = {
   'name':       'APITestTest',
   'host':       'https://www.rackping.com/',
   'port':       443,
   'resolution': 60,
   'paused':     1
}

### end of user settings

headers = {'Content-type': 'application/json',
           'App-Key': api_key
          }

msg_json_error = 'error: decoding JSON failed ...'

def output(s):
    # For a successful API call, response code will be 200 (OK) or 201 (Created)
    if debug:
       print("status=", s.status_code)
    if s.ok:
        jData = json.loads(s.content)
        print(json.dumps(jData))
    else:
        s.raise_for_status()
        pprint(vars(s))
    # end if
# end def output

def main():
    '''Entry point if called as an executable'''

    try:
        sys.stderr.write("Create a request to update 1 check (monitor):\n")
        myResponse = requests.put(url + "/checks/" + checkid, json=form, \
                                  auth=HTTPBasicAuth(user, password), \
                                  headers=headers, \
                                  timeout=timeout)
        output(myResponse)
    except requests.exceptions.RequestException as e:
        sys.exit(e)
    except ValueError as e:
        print(msg_json_error, e)
        sys.exit()
    # end try

    exit(0)
# end def main

if __name__ == '__main__':
    main()
# end if

