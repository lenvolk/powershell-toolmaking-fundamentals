## 1. Set the Azure subscription
Set-AzContext -SubscriptionName $subscriptionName

## 2. List all available Azure VMs
Get-AzVM -Status | Sort-Object -Property Name

## 3. Start an Azure VM
Start-AzVm

## 4. Stop an Azure VM
Stop-AzVm

## Q. Quit Control Room
exit