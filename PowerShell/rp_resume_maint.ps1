# Program: rp_resume_maint.ps1
# Usage: rp_resume_maint.ps1
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
   Write-Error "usage: rp_resume_maint.ps1 id"
   exit
}

$user          = $env::RP_USER
if (!$user) {
   Write-Error "error: run set.sh first"
   exit
}

$password      = $env::RP_PASSWORD
$api_key       = $env::RP_API_KEY
$timeout       = $env::RP_TIMEOUT
$max_redirects = $env::RP_REDIRECTS
$useragent     = $env::RP_USERAGENT
$DEBUG         = $env::RP_DEBUG

$url = $env::RP_SCHEME + $env::RP_DOMAIN + $env::RP_BASE_URL + "/checks/" + $id + '?maintenance=0'

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("Accept",         'application/json')
$headers.Add("Accept-Charset", 'utf-8')
$headers.Add("User-Agent",     $useragent)
$headers.Add("App-key",        $api_key)
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($user + ":" + $password))
$headers.Add("Authorization",  "Basic $auth")

$resp = try {
   Invoke-RestMethod $url -Method Put -Headers $headers -MaximumRedirection $max_redirects -TimeoutSec $timeout -ErrorAction Stop
}
catch {
   $_.Exception.Response
   Write-Error $_
   exit
}

Write-Output $resp
