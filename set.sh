# Program: set.sh
# Purpose: setup envariables for test and sample client programs
# Usage: source set.sh
# Copyright: RackPing USA 2020
# Env: bash
# Note: this file needs to be 'sourced' to set the envariables. Executing this file will incorrectly only transiently set the envariables.

### start of user settings

# Your RackPing account API key (numeric)
export RP_API_KEY=""

# Your RackPing account contact email address
export RP_USER=""

# Your RackPing account contact password
export RP_PASSWORD=""

# RackPing Monitoring Client API timeout (seconds)
export RP_TIMEOUT=5

# Useragent string
export RP_USERAGENT="RackPing/1.0"

# Debug mode (zero when running demo.sh)
export RP_DEBUG=0

### end of user settings

### start of RackPing-reserved settings

export RP_SCHEME="https://"
export RP_DOMAIN=api.rackping.com
export RP_BASE_URL="/api/2.0"
export RP_REDIRECTS=3

### end of RackPing-reserved settings

