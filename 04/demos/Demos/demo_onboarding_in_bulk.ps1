
## First, read the CSV file that contains all of the employees we'd like to onboard
$Employees = Import-Csv -Path ~/Users.csv

## Process each CSV row representing an employee with a foreach loop
foreach ($Employee in $Employees) {

    ## Use splatting to define all of the parameters for our user onboarding script
    ## Each value e.g. FirstName, is the CSV column header.
    $NewUserParams = @{
        'FirstName' = $Employee.FirstName
        'MiddleInitial' = $Employee.MiddleInitial
        'LastName' = $Employee.LastName
        'Title' = $Employee.Title
    }

    ## Since the Location parameter isn't mandatory, only provide this if it's defined
    ## in the Location column
    if ($Employee.Location) { 
        $NewUserParams.Location = $Employee.Location
    }

    ## Create the user account by passing all of the collected parameters
    Write-Host "Creating user account for $($Employee.FirstName) $($Employee.LastName)..."
    New-EmployeeOnboardUser @NewUserParams

    ## Create the employee's AD computer account passing the value in the ComputerName column
	Write-Host "Creating computer account $($Employee.Computername) for $($Employee.FirstName) $($Employee.LastName)..."
    New-EmployeeOnboardComputer -Computername $Employee.Computername -Location $Employee.ComputerLocation
}