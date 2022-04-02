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