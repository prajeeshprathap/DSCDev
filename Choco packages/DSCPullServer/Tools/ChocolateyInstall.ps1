$arguments = @{}

# Let's assume that the input string is something like this, and we will use a Regular Expression to parse the values
# /Port:81 /Edition:LicenseKey /AdditionalTools

# Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
$packageParameters = $env:chocolateyPackageParameters

$ErrorActionPreference = 'Stop'
# Default the values
$pullserverport = 8080
$reportserverport = 9090
$certificateThumbprint = [string]::Empty
$key = [Guid]::NewGuid() | select -expand Guid


function Test-Guid{
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Value
    )
    try{
        [guid]::Parse($Value) | Out-Null
        return $true
    }
    catch{
        return $false
    }
}

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

    if ($arguments.ContainsKey("PullServerPort")) 
    {
        $portValue = $arguments["PullServerPort"]
        $pullserverport = [System.Convert]::ToInt32($portValue)
    }

    if ($arguments.ContainsKey("ReportServerPort")) 
    {
        $portValue = $arguments["ReportServerPort"]
        $reportserverport = [System.Convert]::ToInt32($portValue)
    }

    if ($arguments.ContainsKey("Key")) 
    {
        $key = $arguments["Key"]
        if(-not(Test-Guid -Value $key)){
            throw "$key is not a valid Guid"
        }
    }

    if ($arguments.ContainsKey("Thumbprint")) 
    {
        $certificateThumbprint = $arguments["Thumbprint"]
    }
} 

if((Get-ExecutionPolicy) -eq 'Restricted')
{
    throw 'Execution policy should be set atlease to RemoteSigned..'
}
if(-not(Test-WSMan -ErrorAction SilentlyContinue))
{
    Set-WSManQuickConfig -Force 
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

"Registration key used for the pull server is $key" | Write-Host -ForegroundColor Cyan
"This key will be used when you want to register pull clients to the machine" | Write-Host -ForegroundColor Cyan

$currentFolder = Split-Path -parent $MyInvocation.MyCommand.Definition

$scriptPath = Join-Path $currentFolder "InstallConfiguration.ps1"
if([string]::IsNullOrWhiteSpace($certificateThumbprint)){
    $argumentList = "-NodeName 'localhost' -Key $key -PullServerPort $pullserverport -ReportServerPort $reportserverport"
}
else{
    $argumentList = "-NodeName 'localhost' -Key $key -PullServerPort $pullserverport -ReportServerPort $reportserverport -Thumbprint $certificateThumbprint"
}
Invoke-Expression "& `"$scriptPath`" $argumentList"

Set-DscLocalConfigurationManager -Path .\PullServerConfiguration -Verbose -Force
Start-Sleep -Seconds 8
Start-DscConfiguration .\PullServerConfiguration -Verbose -Wait -Force

