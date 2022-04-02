#region Layout
<#
---------------------------------------------------------
PowerShell Toolmaking Fundamentals Azure VM Control Room
---------------------------------------------------------

1. Set the Azure subscription
2. List all available Azure VMs
3. Start an Azure VM
4. Stop an Azure VM

Q. Quit Control Room

----------------------------------------------------------

#>
#endregion

#region Behavior

<#

1. Set the Azure subscription
    - Prompt for a subscription name. When added, run Set-AzContext and return to menu.
2. List all available Azure VMs
    - Run Get-AzVm and pause after displaying allowing user to review and press a button to return to menu.
3. Start an Azure VM
    - Prompt the user for a VM name and resource group then pass that VM name to Start-AzVM and return to menu.
4. Stop an Azure VM
    - Prompt the user for a VM name and resource group then pass that VM name to Stop-AzVM and return to menu.

Q. Quit Control Room
    - exit the script

#>

#endregion