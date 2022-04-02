@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'AdAccountManagementAutomator'

    # Version number of this module.
    ModuleVersion = '0.0.1'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop','Core')

    # ID used to uniquely identify this module
    GUID = '131f6eda-ccec-4a85-9a93-f234596504cc'

    # Author of this module
    Author = 'Adam Bertram'

    # Company or vendor of this module
    CompanyName = 'My Company'

    # Copyright statement for this module
    Copyright = '(c) Adam Bertram. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'This module automates many tedious tasks that must be performed when onboarding AD accounts'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '7.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @('ActiveDirectory')

    ## Only exporting necessary functions (not the helper function since it's only needed by internal module functions)
    FunctionsToExport = 'New-AmaEmployeeOnboardUser','New-AmaEmployeeOnboardComputer'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        }
    }
}