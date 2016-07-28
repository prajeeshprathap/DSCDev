$arguments = @{}

# Let's assume that the input string is something like this, and we will use a Regular Expression to parse the values
# /Port:81 /Edition:LicenseKey /AdditionalTools

# Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
$packageParameters = $env:chocolateyPackageParameters

$ErrorActionPreference = 'Stop'
# Default the values
$port = 8080


# Now parse the packageParameters using good old regular expression
if ($packageParameters) 
{
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern )
    {
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
        $arguments.Add(
            $_.Groups[$option_name].Value.Trim(),
            $_.Groups[$value_name].Value.Trim())
        }
    }
    else
    {
        throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    if ($arguments.ContainsKey("Port")) 
    {
        $portValue = $arguments["Port"]
        $port = [System.Convert]::ToInt32($portValue)
    }
} 

if(-not(Get-Module -Name xPSDesiredStateConfiguration -ListAvailable))
{
    "xPSDesiredStateConfiguration module is not installed" | Write-Warning
    "This module will be installed using PowerShell PackageManagement" | Write-Verbose

    if(-not(Get-Module -Name PackageManagement -ListAvailable))
    {
        "PowerShell package mananagement is not installed. You need to install WMF 5.0 and start the installation again" | Write-Warning
        "The installation will now be stopped" | Write-Warning
        throw 'PackageManagement module should be installed to proceed'
    }
    Install-Module -Name xPSDesiredStateConfiguration -Confirm:$false -Verbose
}


.\RemovePullConfiguration.ps1 -NodeName 'localhost' -Port $Port

Start-DscConfiguration .\RemovePullConfiguration -Verbose -Force

