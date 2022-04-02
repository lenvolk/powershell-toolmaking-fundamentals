#region AdAccountManagementAutomator highlights

## Common prefix selection explanation

#region Get-AmaAdUser helper function

## What does it do? Replaces Get-ADUser and allows me to
## define custom functionality and reference that instead of repeating myself.

## Doesn't work - Get-AdUser doesn't support multiple users
Get-Aduser 'abertram','jmurphy'

## Works (custom functionality)
Get-AmaAdUser -Username 'abertram','jmurphy'

#endregion

## Doesn't work
Get-Module -ListAvailable -Name AdAccountManagementAutomator

## Create the module folder in the Users module location and
## move the PSM1 file in there.

## Place the module in one of these paths
$env:PSModulePath

New-Item -Path 'C:\Program Files\PowerShell\Modules\AdAccountManagementAutomator' -ItemType Directory
Copy-Item -Path '~/m7/Modules/AdAccountManagementAutomator/AdAccountManagementAutomator.psm1' -Destination 'C:\Program Files\PowerShell\Modules\AdAccountManagementAutomator'

## Should exist now -- Module type is Script
Get-Module -ListAvailable -Name AdAccountManagementAutomator

## Or rely on PowerShell auto-importing
Import-Module -Name AdAccountManagementAutomator

## Commands available to us now
Get-Command -Module AdAccountManagementAutomator

#endregion

#region Perform the same tasks for the other modules. Steps are exactly the same
## Just automate it a bit

'AzureVmDashboard','LogInvestigator' | ForEach-Object {    
    $null = New-Item -Path "C:\Program Files\PowerShell\Modules\$_" -ItemType Directory
    Copy-Item -Path "~/m7/Modules/$_/$_.psm1" -Destination "C:\Program Files\PowerShell\Modules\$_"

    if (Get-Module -ListAvailable -Name $_) {
        Write-Host "The $_ module is available. Yay!" -ForegroundColor Green
    } else {
        Write-Host "The $_ module is not available. Boooo!" -ForegroundColor Red
    }
}

#endregion