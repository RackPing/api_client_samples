# Program: rp_update_contact.ps1
# Usage: rp_update_contact.ps1
# Purpose: Powershell language sample client program for RackPing Monitoring API 2.0
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: Perl5
# Returns: exit status is non-zero on failure
# Note: First set the envariables from ../set.sh

param(
   [string]$id
)
if (!$id) {
   Write-Error "usage: rp_update_contact.ps1 id"
   exit
}
$user          = $env:RP_USER
if (!$user) {
   Write-Error "error: run set.sh first"
   exit
}

$password      = $env:RP_PASSWORD
$api_key       = $env:RP_API_KEY
$timeout       = $env:RP_TIMEOUT
$max_redirects = $env:RP_REDIRECTS
$useragent     = $env:RP_USERAGENT
$DEBUG         = $env:RP_DEBUG

$url = $env:RP_SCHEME + $env:RP_DOMAIN + $env:RP_BASE_URL + "/contacts/" + $id

### start of user settings

$json = @{
    "first"        = 'JohnJohn'
    "last"         = 'Doe'
    "email"        = 'john.doe+' + $api_key + '@example.com'
    "role"         = 'O'                          # user role: A = Admin, O = Operator, B = Billing
    "cellphone"    = '408 555 1212'
    "countrycode"  = '1'                          # numeric telephone country code prefix
    "countryiso"   = 'US'                         # 2-letter country ISO code
} | ConvertTo-Json

### end of user settings

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("Accept",         'application/json')
$headers.Add("Accept-Charset", 'utf-8')
$headers.Add("App-key",        $api_key)
$headers.Add('Content-type',   'application/json')
$headers.Add("User-Agent",     $useragent)
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($user + ":" + $password))
$headers.Add("Authorization",  "Basic $auth")

Write-Error "info: update one contact"

$resp = try {
   Invoke-RestMethod $url -Method Put -Headers $headers –Body $json -MaximumRedirection $max_redirects -TimeoutSec $timeout -ContentType 'application/json' -ErrorAction Stop
}
catch {
   $_.Exception.Response
   Write-Error $_
   exit
}

Write-Output $resp | ConvertTo-Json
