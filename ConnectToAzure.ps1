Import-Module 'C:\Program Files\WindowsPowerShell\Modules\Az.Accounts\2.2.5\Az.Accounts.psm1'

$appId = "abc123"
$tenantId = "00000-00000-0000"
$password = "SuperSecretPassword"
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($appId, $secpasswd)

Connect-AzAccount -ServicePrincipal -Credential $mycreds -Tenant $tenantId
$context =Get-AzContext
$dexResourceUrl='https://database.windows.net/'
$token = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, 
                                $context.Environment, 
                                $context.Tenant.Id.ToString(),
                                    $null, 
                                    [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never, 
                                    $null, $dexResourceUrl).AccessToken
Disconnect-AzAccount