$ErrorActionPreference = 'Stop'
if((Get-ExecutionPolicy) -eq 'Restricted')
{
    throw 'Execution policy should be set atlease to RemoteSigned..'
}
if(-not(Test-WSMan -ErrorAction SilentlyContinue))
{
    Set-WSManQuickConfig -Force 
}

if(-not(Get-Module -Name PackageManagement -ListAvailable))
{
    throw 'PackageManagement module should be installed to proceed'
}

if(-not(Get-Module -Name xPSDesiredStateConfiguration -ListAvailable))
{
    Install-Module -Name xPSDesiredStateConfiguration -Confirm:$false -Verbose
}

.\DSCComplainceServer.ps1 -NodeName 'localhost'

Set-DscLocalConfigurationManager -Path .\ComplainceServerConfiguration -Verbose -Force
Start-DscConfiguration .\ComplainceServerConfiguration -Verbose -Force