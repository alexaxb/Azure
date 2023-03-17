Import-Module Az.ResourceGraph -ErrorAction Stop

# get resource from ARM
$Resources = Search-AzGraph -Query "resources | where type in~ ('Microsoft.Compute/virtualMachines') and subscriptionId == '0000-00000000-0000-0000' and resourceGroup =~ 'resource-group-name'"

# user from AAD
$TenatDomainName = "contoso.com"
$Body = @{
  Grant_Type    = "client_credentials"
  Scope         = "https://graph.microsoft.com/.default"
  client_Id     = 'clientid'
  Client_Secret = 'supersecretpassword'
}

$RequestToken = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenatDomainName/oauth2/v2.0/token" -Method POST -Body $Body
$authToken = $RequestToken.access_token
$uri = "https://graph.microsoft.com/beta/users/{user_guid}"
$uri = "https://graph.microsoft.com/beta/users('$AdeleVance@contoso.com')"

$data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($authToken)" } -Uri $uri -Method Get
$Result += $Data.Value
$NextLink = $data.'@odata.nextLink'

#Make api calls until @Odata.nextlink is empty
#As long as there is a @odata.nextlink there are more results to get
while ($NextLink -like "*https*") {
  $NextLink = $data.'@odata.nextLink'
  Write-Host "Gettings more results" -ForegroundColor Yellow
  if ($NextLink) {
    $Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($authToken)" } -Uri $NextLink -Method Get
    $AllDevices += $Data.Value
  }

}
