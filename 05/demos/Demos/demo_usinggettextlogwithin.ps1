. ~/logfile_functions.ps1

Get-Command -Name Get-TextLogEventWithin

Get-TextLogEventWithin -ComputerName WIN19-DC -StartTimestamp '2-27-2022 00:00' -EndTimestamp (Get-Date)