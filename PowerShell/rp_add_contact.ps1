# Program: rp_add_contact.ps1
# Usage: rp_add_contact.ps1
# Purpose: Powershell language sample client program for RackPing Monitoring API 2.0
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: Perl5
# Returns: exit status is non-zero on failure
# Note: First set the envariables from ../set.sh

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

$url = $env:RP_SCHEME + $env:RP_DOMAIN + $env:RP_BASE_URL + "/contacts"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("Accept",         'application/json')
$headers.Add("Accept-Charset", 'utf-8')
$headers.Add("App-key",        $api_key)
$headers.Add('Content-type',   'application/json')
$headers.Add("User-Agent",     $useragent)
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($user + ":" + $password))
$headers.Add("Authorization",  "Basic $auth")

### start of user settings

$pw=-join ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | ForEach-Object {[char]$_} | Get-Random -Count 10)

$json = @{
    "first"        = 'John'
    "last"         = 'Doe'
    "email"        = 'john.doe+' + $api_key + '@example.com'
    "role"         = 'O'                          # user role: A = Admin, O = Operator, B = Billing
    "cellphone"    = '408 555 1212'
    "countrycode"  = '1'                          # numeric telephone country code prefix
    "countryiso"   = 'US'                         # 2-letter country ISO code
    "lang"         = 'en'                         # language for new user and password reminder email
    "timezone"     = 'America/New_York'
    "sendemail"    = 0                            # send password reminder email [0|1]
    "alertable"    = 'N'                          # enable paid AlertPro user [Y|N]
    "pw"           = $pw                          # user password. blank disables password reminder email.
} | ConvertTo-Json

### end of user settings

$resp = try {
   Invoke-RestMethod $url -Method Post -Headers $headers -Body $json -MaximumRedirection $max_redirects -TimeoutSec $timeout -ContentType 'application/json' -ErrorAction Stop
}
catch {
   $_.Exception.Response
   Write-Error $_
   exit
}

Write-Output $resp | ConvertTo-Json
