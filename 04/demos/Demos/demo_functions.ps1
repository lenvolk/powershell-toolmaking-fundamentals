. ~/ADOnboardFunctions.ps1

Get-Command New-EmployeeOnboardUser,New-EmployeeOnboardComputer

## Shouldn't exist
Get-AdUser 'abertram'

New-EmployeeOnboardUser -FirstName 'Adam' -MiddleInitial 'D' -LastName 'Bertram' -Title 'Sanitation Engineer'

## Should exist
Get-AdUser 'abertram'

## Shouldn't exist
Get-AdComputer 'ABERTRAMPC'

New-EmployeeOnboardComputer -ComputerName ABERTRAMPC

## Should exist
Get-AdComputer 'ABERTRAMPC'