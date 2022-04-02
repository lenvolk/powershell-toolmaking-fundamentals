function New-AmaEmployeeOnboardUser {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to perform all routine
		tasks that must be done when onboarding a new employee user account.
        
	.EXAMPLE
		PS> New-AmaEmployeeOnboardUser -FirstName 'adam' -MiddleInitial D -LastName Bertram -Title 'Dr. Awesome'
	
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

    .PARAMETER DefaultPassword
        The password the AD user account will initially be set with.

    .PARAMETER DefaultGroup
        The AD group the user account will be made a member of.
	#>
	[CmdletBinding()]
	param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Firstname,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
		[string]$MiddleInitial,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
		[string]$LastName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
		[string]$Location = 'OU=Corporate Users',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
		[string]$Title,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$DefaultPassword = 'p@$$w0rd12', ## Not the best use of storing the password clear text

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$DefaultGroup = 'Gigantic Corporation Inter-Intra Synergy Group'
	)
	process {

		$DomainDn = (Get-AdDomain).DistinguishedName
			
		$Username = "$($FirstName.SubString(0, 1))$LastName"
		## Check if an existing user already has the first intial/last name username taken
		try {
            if (Get-AmaADUser -Username $Username) {
				## If so, check to see if the first initial/middle initial/last name is taken.
				$Username = "$($FirstName.SubString(0, 1))$MiddleInitial$LastName"
				if (Get-AmaADUser -Username $Username) {
					throw "No acceptable username schema could be created"
				}
			}
		} catch {
            throw $_.Exception.Message
        }
		$NewUserParams = @{
            'UserPrincipalName' = $Username
            'Name' = $Username
            'GivenName' = $FirstName
            'Surname' = $LastName
            'Title' = $Title
            'SamAccountName' = $Username
            'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
            'Enabled' = $true
            'Initials' = $MiddleInitial
            'Path' = "$Location,$DomainDn"
            'ChangePasswordAtLogon' = $true
        }
			
		New-AdUser @NewUserParams
		Add-ADGroupMember -Identity $DefaultGroup -Members $Username
        $Username
	}
}

function New-AmaEmployeeOnboardComputer {
	<#
	.SYNOPSIS
		This function is part of the Active Directory Account Management Automator tool.  It is used to perform all routine
		tasks that must be done when onboarding a new AD computer account.
	.EXAMPLE
		PS> New-AmaEmployeeOnboardComputer -FirstName 'adam' -MiddleInitial D -LastName Bertram -Title 'Dr. Awesome'
	
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
        [ValidateNotNullOrEmpty()]
        [string]$Computername,

		[Parameter()]
        [ValidateNotNullOrEmpty()]
		[string]$Location = 'OU=Corporate Computers'
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

function Get-AmaAdUser {
	<#
	.SYNOPSIS
		This is a helper function for the AdAccountManagementAutomator Powershell module.  It is used by
		various other functions in the module to find AD user objects.
	.EXAMPLE
		PS> Get-AmaAdUser -Username adam
	
		This example queries Active Directory for a user object with the identity of 'adam'
	.PARAMETER Username
	 	One or more Active Directory usernames separated by commas
	#>
	[CmdletBinding()]
	param (
		[string[]]$Username
	)
	process {
		try {
			## Build the AD filter to find all of the user objects
			$Filter = "samAccountName -eq '"
			$Filter += $Username -join "' -or samAccountName -eq '"
			$Filter += "'"
			## Attempt to find the username
			$UserAccount = Get-AdUser -Filter $Filter
			if ($UserAccount) {
				$UserAccount
			}
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}