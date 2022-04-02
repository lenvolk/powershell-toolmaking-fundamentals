param($FirstName,$MiddleInitial,$LastName,$Location = 'OU=Corporate Users',$Title, $Password = 'P@$$w0rd12', $Group = 'Gigantic Corporation Inter-Intra Synergy Group')

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

## Convert the password to a secure string
$encPassword = (ConvertTo-SecureString $Password -AsPlainText -Force)

try {
	## Get the distinguished name of the AD domain the user is being created in
	$domainDn = (Get-AdDomain).DistinguishedName

	## Create the user. Use splatting due to many parameters
	$NewUserParams = @{
	    'UserPrincipalName' = $username
	    'Name' = $username
	    'GivenName' = $FirstName
	    'Surname' = $LastName
	    'Title' = $Title
	    'SamAccountName' = $username
	    'AccountPassword' = $encPassword
	    'Enabled' = $true
	    'Initials' = $MiddleInitial
	    'Path' = "$Location,$domainDn"
	    'ChangePasswordAtLogon' = $true
	}
	New-AdUser @NewUserParams
} catch {
	throw $_.Exception.Message
}

Write-Host "Created username $UserName."

## Add the user to the default group
Add-ADGroupMember -Identity $Group -Members $Username
Write-Host "Added $Username to $Group group."