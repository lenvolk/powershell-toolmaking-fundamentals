function Show-Menu {
    param (
        [string]$Title = 'PowerShell Toolmaking Fundamentals Azure VM Control Room'
    )
    ## Refresh the menu
    Clear-Host

    ## Create the menu
    $sharedParams = @{
        'ForegroundColor' = 'Blue'
    }

    Write-Host @sharedParams '---------------------------------------------------------'
    Write-Host @sharedParams $Title
    Write-Host @sharedParams '---------------------------------------------------------'
    
    Write-Host @sharedParams '1. Set the Azure subscription'
    Write-Host @sharedParams '2. List all available Azure VMs'
    Write-Host @sharedParams '3. Start Azure VM(s)'
    Write-Host @sharedParams '4. Stop Azure VM(s)'

    Write-Host @sharedParams 'Q. Quit Control Room'
}

do {
    ## Display the main menu
    Show-Menu

    ## Allow the user to provide input to select a menu option
    $selection = Read-Host 'Please make a selection'

    ## Use conditional logic to perform some kind of action based on the menu option the user picked
    switch ($selection) {
        '1' {
            $subscriptionName = Read-Host 'Subscription name'
            Set-AzContext -SubscriptionName $subscriptionName
        } '2' {
            Get-AzVM -Status | Sort-Object -Property Name | Format-Table -Property Name,ResourceGroupName,PowerState -AutoSize
        } '3' {
            ## Relying on the command's mandatory parameters (Name and ResourceGroupName) to prompt the user
            ## for a selection.
            Start-AzVm | Format-Table
        } '4' {
            ## Relying on the command's mandatory parameters (Name and ResourceGroupName) to prompt the user
            ## for a selection.
            Stop-AzVm | Format-Table
        } default {
            ## Return an error if any unhandled menu option is provided
            if ($_ -ne 'q') {
                Write-Error -Message "$_ is an unrecognized menu option. Please try again."
            }
        }
    }

    if ($selection -ne 'q') {
        ## Pause the menu to keep the output from the menu option shown on the screen
        ## if we're not existing the tool.
        Pause
    } else {
        Write-Host 'Thanks for using Azure VM Control Room!' -ForegroundColor Green
    }
}
until ($selection -eq 'q') ## Exit the do loop (and the entire script) when Q is selected