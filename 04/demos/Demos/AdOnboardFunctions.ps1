function New-EmployeeOnboardUser {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to perform all routine
		tasks that must be done when onboarding a new employee user account.
	.EXAMPLE
		PS> New-EmployeeOnboardUser -FirstName 'adam' -MiddleInitial D -LastName Bertram -Title 'Dr. Awesome'
	
		This example creates an AD username based on company standards into a company-standard OU and adds the user
		into the company-standard main user group.
	.PARAMETER FirstName
	 	The first name of the employee
	.PARAMETER MiddleInitial
		The middle initial of the employee
	.PARAMETER LastName
		The last name of the employee
	.PARAMETER Title
		The current job title of the employee
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Firstname,

		[Parameter()]
		[string]$MiddleInitial,

		[Parameter(Mandatory)]
		[string]$LastName,

		[Parameter()]
		[string]$Location = 'OU=Corporate Users',

		[Parameter()]
		[string]$Title,

		[Parameter()]
		[string]$Password = 'P@$$w0rd12',

		[Parameter()]
		[string]$Group = 'Gigantic Corporation Inter-Intra Synergy Group'
	)
	
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

}

function New-EmployeeOnboardComputer {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to perform all routine
		tasks that must be done when onboarding a new AD computer account.
	.EXAMPLE
		PS> New-EmployeeOnboardComputer -FirstName 'adam' -MiddleInitial D -LastName Bertram -Title 'Dr. Awesome'
	
		This example creates an AD username based on company standards into a company-standard OU and adds the user
		into the company-standard main user group.
	.PARAMETER Computername
	 	The name of the computer to create in AD
	.PARAMETER Location
		The AD distinguishedname of the OU that the computer account will be created in
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[string]$Computername,

		[Parameter(Mandatory)]
		[string]$Location
	)

	try {
	    if (Get-AdComputer $Computername) {
		    throw "The computer name '$Computername' already exists"
	    }
	} catch {
		## Return an error only if Get-AdComputer does not return a message about not finding a computer account
		if (-not $_.Exception.Message.StartsWith('Cannot find an object with identity')) {
			throw $_.Exception.Message
		}
	}
	
	$DomainDn = (Get-AdDomain).DistinguishedName
	$DefaultOuPath = "$Location,$DomainDn"
	
	New-ADComputer -Name $Computername -Path $DefaultOuPath

}