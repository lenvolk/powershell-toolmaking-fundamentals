[CmdletBinding()]
param(
	[Parameter()]	
	[string]$ComputerName = 'localhost',
	
	[Parameter(Mandatory)]
	[datetime]$StartTimestamp,
	
	[Parameter(Mandatory)]
	[datetime]$EndTimestamp,
	
	[Parameter()]
	[string]$LogFileExtension = 'log',

	[Parameter()]
	[string[]]$ExcludeFileNames = 'edb'
)

## Only find the administrative shares
$shares = Get-CimInstance -ComputerName $ComputerName -Class Win32_Share| Where-Object { $_.Path -match '^\w{1}:\\$' }

## Collect paths we can eventually pass to Get-Childitem to search through
$locations = @()
foreach ($share in $shares) {
	## Create the path
	$path = "\\$ComputerName\$($share.Name)"

	## Ensure we can access the path
  if (-not (Test-Path -Path $path)) {
    Write-Warning "Unable to access the [$share] share on [$Computername]."
  } else {
		## Add the available path to the locations array to use later
    $locations += $path
  }
}

## Figure out how to enumerate all of log files on all drives on a remote computer

$gciParams = @{
	Path = $locations ## Only available shares
	Filter = "*.$LogFileExtension" ## Only log files
	Recurse = $true ## All subdirectories
	Force = $true ## even hidden files
	ErrorAction = 'Ignore' ## Skip permission denied errors
	File = $true ## Only files
}

## Now figure out how to limit those log files down to a last write time between a start and end timestamp

## Build the Where-Object scriptblock on a separate line due to it's length
$whereFilter = {
    ($_.LastWriteTime -ge $StartTimestamp) -and
    ($_.LastWriteTime -le $EndTimestamp) -and
    ($_.Length -ne 0) -and
    ($_.BaseName -notin $ExcludeFileNames)
}

## Find all interesting log files
Get-ChildItem @gciParams | Where-Object $whereFilter