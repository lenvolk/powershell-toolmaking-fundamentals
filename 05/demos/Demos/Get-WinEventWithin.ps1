[CmdletBinding()]
param(
	[Parameter()]
	[string]$ComputerName = 'localhost',
	
	[Parameter(Mandatory)]
	[datetime]$StartTimestamp,
	
	[Parameter(Mandatory)]
	[datetime]$EndTimestamp
)

## Create a filter to pass to Get-WinEvent to search over all events in all logs with at least one event in it
$Logs = (Get-WinEvent -ListLog * -ComputerName $ComputerName | Where-Object { $_.RecordCount }).LogName
$FilterTable = @{
	'StartTime' = $StartTimestamp
	'EndTime' = $EndTimestamp
	'LogName' = $Logs
}

## Find all events within the timeframe
Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable