## Whip together a "brainstorming" script that allows me to pull together all of the rough
## code I need for this tool

## Define all of the variables that will be in the script (probably as parameters) here so
## we can play with code and have these variables represent potential values the script will have

$ComputerName = 'WIN19-DC'
$StartTimestamp = '2-26-2022 00:00'
$EndTimestamp = (Get-Date) ## Now

## Get-WinEvent can find all event logs. If this returns "RPC Server unavailable", ensure you
## have the "Remote Event Log Management" Windows firewall rule enabled on $ComputerName
Get-WinEvent -ListLog * -ComputerName $ComputerName

## Narrow this down to only event logs with at least one record in it
(Get-WinEvent -ListLog * -ComputerName $ComputerName | Where-Object { $_.RecordCount })

## I need the log names to pass to Get-WinEvent. Create an array of log names
$Logs = (Get-WinEvent -ListLog * -ComputerName $ComputerName | where { $_.RecordCount }).LogName

## What's in $Logs?
$Logs

## Create the filter table we'll pass to Get-WinEvent
$FilterTable = @{
	'StartTime' = $StartTimestamp
	'EndTime' = $EndTimestamp
	'LogName' = $Logs
}

## Create the line we really need to search through all of the logs

## Try it out and see what happens. Any errors? Does it return events only within your timeframe?
## Too many to check
Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable

## Grab the first object and pass to Select-Object to see all of the properties available
Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable | select -first 1 -Property *

## Get a summary to ensure we got the events we're looking for. Look good? Here's your time to spot check
$matchedEvents = Get-WinEvent -ComputerName $ComputerName -FilterHashtable $FilterTable -ErrorAction 'Ignore' | Group-Object LogName
$matchedEvents

## Use whatever code you believe that would allow you to spotcheck the results before rolling this code
## into a script.
$matchedEvents | ForEach-Object {
    [pscustomobject]@{
        LogName = $_.Group[0].LogName
        NewestEvent = ($_.Group.TimeCreated | Measure-Object -Maximum).Maximum
        OldestEvent = ($_.Group.TimeCreated | Measure-Object -Minimum).Minimum
    }
}