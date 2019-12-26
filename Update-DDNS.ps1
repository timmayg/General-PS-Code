<#
This PS will determine the Internet IP assigned to the Internet facing interface. 

It will then query GoDaddy to determine the if the A Record for DDNS is accurate. 
If it is accurate the script will exit.
If it is not accurate the script will modify the record. 

Note:   This has ONLY been tested using GoDaddy for the DNS Provider.
#>

#
#   Obtain WANIP from ipGeoLocation
#     I like ipGeoLocation because it provides a lot more than just an IP Address
#     A lot of that cool info requires a login, they are free.   We wont be 
#     authenticating to ipGeoLocation in this script though because its not needed. 
# 
$wanip_url = 'https://api.ipgeolocation.io/getip'
$wanip = Invoke-RestMethod -Method Get -URI $wanip_url

#
#   Obtain A Record Data from GoDaddy
# 
$headers = New-Object 'System.Collections.Generic.Dictionary[[String],[String]]'
$headers.Add('Authorization', 'sso-key ENTER-YOUR-APIKEY:ENTER-YOUR-APIKEY-SECRET')
$headers.Add('accept', 'application/json')
$headers.Add('Content-type', 'application/json')
$headers.Add('Accept-Encoding', 'gzip, deflate')
#
$domain = 'your-domain.com'
$a_record = 'ddns-record'
$vpnip_url = 'https://api.godaddy.com/v1/domains/' + $domain + '/records/A/' + $a_record
$vpnip = Invoke-RestMethod -Method Get -URI $vpnip_url -Headers $headers
#
#  Compare the two IP Address to see if they are the same.  
#    If they are then exit,  if they are not then update the GoDaddy IP.  
#
if ($wanip.ip -ne $vpnip.data) {  
    $update = @(@{ttl=600;data=$wanip.ip; })
    $body = Convertto-Json $update
    Invoke-WebRequest https://api.godaddy.com/v1/domains/$domain/records/A/$name -method put -headers $headers -Body $body -ContentType "application/json"
    }  
    else {  
        Write-Host -ForegroundColor Green "IP Addresses are the same."   
    }   
#



