## What's a manifest look like?

## New-ModuleManifest syntax to create a new manifest

## FunctionsToExport attribute

$newManifestParams = @{
    RequiredModules = 'ActiveDirectory'
    PowerShellVersion = '7.0'
    Author = 'Adam Bertram'
    FunctionsToExport = 'New-AmaEmployeeOnboardUser','New-AmaEmployeeOnboardComputer'
    CompanyName = 'My Company'
    Description = 'This module automates many tedious tasks that must be performed when onboarding AD accounts'
    CompatiblePSEditions = @('Desktop','Core')
    Path = 'C:\Program Files\PowerShell\Modules\AdAccountManagementAutomator\AdAccountManagementAutomator.psd1'
    RootModule = 'AdAccountManagementAutomator'
}

New-ModuleManifest @newManifestParams

## Module now shows up as a manifest module

Import-Module AdAccountManagementAutomator
Get-Module -ListAvailable -Name AdAccountManagementAutomator

#region Build the manifests for the other modules

$newManifestParams = @{
    RequiredModules = 'Az'
    PowerShellVersion = '7.0'
    Author = 'Adam Bertram'
    CompanyName = 'My Company'
    Description = 'This module provides an interactive menu to control Azure virtual machines.'
    CompatiblePSEditions = @('Desktop','Core')
    Path = 'C:\Program Files\PowerShell\Modules\AzureVmDashboard\AzureVmDashboard.psd1'
    RootModule = 'AzureVmDashboard'
}

New-ModuleManifest @newManifestParams

$newManifestParams = @{
    RequiredModules = 'LogInvestigator'
    PowerShellVersion = '7.0'
    Author = 'Adam Bertram'
    CompanyName = 'My Company'
    Description = 'This module automates searching for Windows events and text logs to find events within a given timeframe.'
    CompatiblePSEditions = @('Desktop','Core')
    Path = 'C:\Program Files\PowerShell\Modules\LogInvestigator\LogInvestigator.psd1'
    RootModule = 'LogInvestigator'
}

New-ModuleManifest @newManifestParams

#endregion