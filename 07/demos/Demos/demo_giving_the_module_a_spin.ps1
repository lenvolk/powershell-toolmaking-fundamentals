## Check of the module is there and commands are available to confirm
Get-Command -Module AdAccountManagementAutomator

## Ensure the AD users don't exist first
Get-AdUser bjones | Remove-AdUser
Get-AdUser bdjones | Remove-AdUser

## Create a sample user account
$parameters = @{
	FirstName = 'Bob'
	MiddleInitial = 'D'
	LastName = 'Jones'
	Title = 'President'
}

New-AmaEmployeeOnboardUser @parameters

## Yay! It's now here.
Get-AdUser bjones

## Create a sample computer account

## Ensure the computer account doesn't exist first
Get-AdComputer BJONESPC | Remove-AdComputer

$parameters = @{
	ComputerName = 'BJONESPC'
    Location = 'OU=Corporate Computers'
}

New-AmaEmployeeOnboardComputer @parameters

Get-AdComputer BJONESPC

#region  Remove any existing users or computers first

## Throw away code to get the job done
'abertram','adbertram','jmurphy','jemurphy' | ForEach-Object {
    try {
        Get-AdUser $_  | Remove-AdUser -Confirm:$false
    } catch {

    }
}

'ADAMCOMPUTER','JOECOMPUTER' | ForEach-Object {
    try {
        Get-AdComputer $_  | Remove-AdComputer -Confirm:$false
    } catch {

    }
}

#endregion

##region It's now easier to create users in bulk

## This code snippet is the same from the Tool #1: Active Directory
## Account Automator course module. We're just using the module's
## functions now. Plus, they are always available to you!

Import-Csv -Path '~/m7/Users.csv' | ForEach-Object {

    $NewUserParams = @{
        'FirstName' = $_.FirstName
        'MiddleInitial' = $_.MiddleInitial
        'LastName' = $_.LastName
        'Title' = $_.Title
    }

    if ($_.Location) { 
        $NewUserParams.Location = $_.Location
    }

    Write-Host "Creating user account for $($_.FirstName) $($_.LastName)..."
    New-AmaEmployeeOnboardUser @NewUserParams

    Write-Host "Creating computer account $($_.Computername) for $($_.FirstName) $($_.LastName)..."
    New-AmaEmployeeOnboardComputer -Computername $_.Computername -Location $_.ComputerLocation
}

#endregion