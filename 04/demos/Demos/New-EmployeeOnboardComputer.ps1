param($Computername, $Location = 'OU=Corporate Computers')

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