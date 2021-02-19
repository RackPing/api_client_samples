# Program: rp_schedule_maint.ps1
# Usage: rp_schedule_maint.ps1
# Purpose: Powershell language sample client program for RackPing Monitoring API 2.0
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: Perl5
# Returns: exit status is non-zero on failure
# Note: First set the envariables from ../set.sh

param(
   [string]$id,
   [string]$start,
   [string]$end
)
if (!$id) {
   Write-Error "usage: rp_schedule_maint.ps1 id start end"
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

$url = $env:RP_SCHEME + $env:RP_DOMAIN + $env:RP_BASE_URL + "/checks/" + $id + '?start_maintenance=' + $start + '&end_maintenance=' + $end
$url = [uri]::EscapeUriString($url)

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("Accept",         'application/json')
$headers.Add("Accept-Charset", 'utf-8')
$headers.Add("User-Agent",     $useragent)
$headers.Add("App-key",        $api_key)
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($user + ":" + $password))
$headers.Add("Authorization",  "Basic $auth")

Write-Error "info: start maintenance window on one check"

$resp = try {
   Invoke-RestMethod $url -Method Put -Headers $headers -MaximumRedirection $max_redirects -TimeoutSec $timeout -ContentType 'application/json' -ErrorAction Stop
}
catch {
   $_.Exception.Response
   Write-Error $_
   exit
}

Write-Output $resp | ConvertTo-Json -Depth 10
