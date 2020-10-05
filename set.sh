# Program: set.sh
# Purpose: configure envariables for RackPing Monitoring API 2.0 sample client programs
# Env: bash
# Usage: source set.sh
# Note: this file needs to be 'sourced' to set the envariables. Executing this file will incorrectly only transiently set the envariables.

### start of user settings

# Your RackPing account API key
export RP_API_KEY=

# Your RackPing account contact email address
export RP_USER=

# Your RackPing account contact password
export RP_PASSWORD=

# RackPing Monitoring Client API timeout
export RP_TIMEOUT=5.0

### end of user settings

### start of RackPing-reserved settings

export RP_SCHEME="https://"
export RP_DOMAIN=api.rackping.com
export RP_BASE_URL="/api/2.0"
export RP_REDIRECTS=3

### end of RackPing-reserved settings
