param($FirstName,$MiddleInitial,$LastName,$Location = 'OU=Corporate Users',$Title, $Password = 'P@$$w0rd12')

## Figure out the username to use
$username = "$($FirstName.SubString(0,1))$LastName"
## Check if an existing user already has the first intial/last name username taken

## Must use a try/catch block because Get-AdUser returns a hard-terminating error and ignores -ErrorAction
try {
    if (Get-ADUser $username) {
        ## If so, check to see if the first initial/middle initial/last name is taken.
        $username = "$($FirstName.SubString(0,1))$MiddleInitial$LastName"
        if (Get-AdUser $username) {
            throw "No available usernames!"
        }
    }
} catch {
	## Return an error only if Get-AdUser does not return a message about not finding a user account
	if (-not $_.Exception.Message.StartsWith('Cannot find an object with identity')) {
		throw $_.Exception.Message
	}
}

Write-Host "The username will be $UserName."

## Define the password securely

## Create the user

## Add the user to the default group