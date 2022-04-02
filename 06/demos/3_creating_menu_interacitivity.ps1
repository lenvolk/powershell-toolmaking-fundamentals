do {

    #region Display the menu
    $sharedParams = @{
        'ForegroundColor' = 'Blue'
    }
    
    Write-Host @sharedParams '---------------------------------------------------------'
    Write-Host @sharedParams 'Azure VM Control Room'
    Write-Host @sharedParams '---------------------------------------------------------'
    
    Write-Host @sharedParams '1. Set the Azure subscription'
    Write-Host @sharedParams '2. List all available Azure VMs'
    Write-Host @sharedParams '3. Start Azure VM(s)'
    Write-Host @sharedParams '4. Stop Azure VM(s)'
    
    Write-Host @sharedParams 'Q. Quit Control Room'
    #endregion

    ## Allow the user to provide input to select a menu option
    $selection = Read-Host 'Please make a selection'

    ## Use conditional logic to perform some kind of action based on the menu option the user picked
    switch ($selection) {
        '1' {
            ## do the thing here
        } '2' {
            ## do the thing here
        } '3' {
            ## do the thing here
        } '4' {
            ## do the thing here
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