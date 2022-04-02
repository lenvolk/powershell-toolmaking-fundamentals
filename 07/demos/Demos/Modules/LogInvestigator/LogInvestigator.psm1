function Get-WinEventWithin {
	<#
	.SYNOPSIS
	    This function finds all events in all event logs on a local or remote computer between a start and end time	
	.EXAMPLE
		PS> Get-WinEventWithin -StartTimestamp '04-15-15 04:00' -EndTimestamp '04-15-15 08:00'

        This example finds all events in all event logs from April 15th, 2015 at 4AM to April 15th, 2015 at 8AM.
	.PARAMETER Computername
        The computer in which you'd like to find event log entries on.  If this is not specified, it will default to localhost.
	.PARAMETER StartTimestamp
        The earlier time of the event you'd like to find an event 
	.PARAMETER EndTimestamp
        The latest time of the event you'd like to find 
	#>
	[CmdletBinding()]
	param (
		[Parameter()]
        [string]$Computername = 'localhost',

        [Parameter(Mandatory)]
        [datetime]$StartTimestamp,

        [Parameter(Mandatory)]
        [datetime]$EndTimestamp
	)
	process {
		try {
            $Logs = (Get-WinEvent -ListLog * -ComputerName $ComputerName | Where-Object { $_.RecordCount }).LogName
            $FilterTable = @{
	            'StartTime' = $StartTimestamp
	            'EndTime' = $EndTimestamp
	            'LogName' = $Logs
            }
		
            Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable
		} catch {
			throw $_.Exception.Message
		}
	}
}

function Get-TextLogEventWithin {
	<#
	.SYNOPSIS
	    This function finds all files matching a specified file extension that have a last write time
        between a specific start and end time.
	.EXAMPLE
		PS> Get-TextLogEventWithin -Computername MYCOMPUTER -StartTimestamp '04-15-15 04:00' -EndTimestamp '04-15-15 08:00' -LogFileExtension 'log'

        This example finds all .log files on all drives on the remote computer MYCOMPUTER from April 15th, 2015 at 4AM to April 15th, 2015 at 8AM.
	.PARAMETER Computername
        The computer name you'd like to search for text logs on.
	.PARAMETER StartTimestamp
        The earliest last write time of a log file you'd like to find
	.PARAMETER EndTimestamp
        The latest last write time of a log file you'd like to find
    .PARAMETER LogFileExtension
        The file extension you will be limiting your search to. This defaults to 'log'
    .PARAMETER ExcludeFileNames
        Includes all file names that will be filtered out from being returned.
	#>
	[CmdletBinding()]
	param (
        [ValidateScript({Test-Connection -ComputerName $_ -Quiet -Count 1})]
        [Parameter()]
		[string]$Computername = 'localhost',

        [Parameter(Mandatory)]
        [datetime]$StartTimestamp,

        [Parameter(Mandatory)]
        [datetime]$EndTimestamp,

		[Parameter()]
        [ValidateSet('txt','log')]
        [string]$LogFileExtension = 'log',

        [Parameter()]
	    [string[]]$ExcludeFileNames = 'edb'
	)
	process {
		try {
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
		} catch {
			throw $_.Exception.Message
		}
	}
}