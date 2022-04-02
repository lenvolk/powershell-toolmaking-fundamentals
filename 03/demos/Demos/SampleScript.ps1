
## Run a command
Get-ChildItem

## Discover commands
Get-Command

## Get some help
Get-Help Get-ChildItem

ping 127.0.0.1

## Want to do more than one thing at a time
Get-ChildItem; Get-Command -Name Get-ChildItem

## Maybe you want to introduce some logic or do something to some files; take another action

## hard to read
foreach ($file in (Get-ChildItem -Filter '*.txt')) { Write-Host "Reading file [$($file.FullName)]..."; Write-Host '---------------------------'; Get-Content -Path $file.FullName }

## space it out to look better
foreach ($file in (Get-ChildItem -Filter '*.txt')) {
	Write-Host "Reading file [$file.FullName]..."
	Write-Host '---------------------------'
	Get-Content -Path $file.FullName
}

## You now have to copy/paste this into the console every time

## Create a script
notepad

## Save as PS1 and show saving as PS1

## Execute the script. You don't have to copy/paste. It's a little package now. The script does the exact
## same thing as copying/pasting into the console but easier to read, easily shareable, and prepares
## you for larger projects

