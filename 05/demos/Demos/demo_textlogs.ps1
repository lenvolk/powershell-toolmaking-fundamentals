## Define all of the variables that will be in the script (probably as parameters) here so
## we can play with code and have these variables represent potential values the script will have

$ComputerName = 'WIN19-DC'

#region Enumerate all shares on the remote computer

## Only find the administrative shares

## All shares
$shares = Get-CimInstance -ComputerName $ComputerName -Class Win32_Share
$shares

## Only interested in admin shares - Figure out the regex to match them (shares with a single letter and ending in a dollar sign)
$shares[0].Path -match '^\w{1}:\\$' ## no match - good
$shares[1].Path -match '^\w{1}:\\$' ## match - good

## Include the regex in a Where-Object filter to only find admin shares
$shares = Get-CimInstance -ComputerName $ComputerName -Class Win32_Share| Where-Object { $_.Path -match '^\w{1}:\\$' }

## Confirm only admin shares
$shares

#endregion

#region Collect paths we can eventually pass to Get-Childitem to search through
$locations = @()
foreach ($share in $shares) {
	## Create the path
	$path = "\\$ComputerName\$($share.Name)"

	## Ensure we can access the path. Always use error handling and add conditions as necessary!
    if (-not (Test-Path -Path $path)) {
        Write-Warning "Unable to access the [$share] share on [$Computername]."
    } else {
        ## Add the available path to the locations array to use later
        $locations += $path
    }
}

## UNC paths look good?
$locations

#endregion

#region Figure out the params to enumerate all of log files on all drives on a remote computer

## Limiting to .log files

$LogFileExtension = 'log'

$gciParams = @{
	Path = $locations ## Only available shares
	Filter = "*.$LogFileExtension" ## Only log files
	Recurse = $true ## All subdirectories
	Force = $true ## even hidden files
	ErrorAction = 'Ignore' ## Skip permission denied errors
	File = $true ## Only files
}

#endregion

#region Now figure out how to limit those log files down to a last write time between a start and end timestamp

$StartTimestamp = '2-26-2022 00:00'
$EndTimestamp = (Get-Date) ## Now

## Build the Where-Object scriptblock on a separate line due to it's length
$whereFilter = {($_.LastWriteTime -ge $StartTimestamp) -and ($_.LastWriteTime -le $EndTimestamp) -and ($_.Length -ne 0)}

## Find all interesting log files. Do the dates look right? Are the results so far what you'd expect you'd like to 
## investigate further?
Get-ChildItem @gciParams | Where-Object $whereFilter

## edb.log files are not text log files so let's exclude them

$whereFilter = {
    ($_.LastWriteTime -ge $StartTimestamp) -and
    ($_.LastWriteTime -le $EndTimestamp) -and
    ($_.Length -ne 0) -and
    ($_.BaseName -ne 'edb')
}

Get-ChildItem @gciParams | Where-Object $whereFilter

#endregion