ErrorActionPreference = 'Stop'
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

$registrationKey = '62f25315-62f1-47eb-a091-fc1f7b70f40e'
.\DSCComplainceServer.ps1 -NodeName 'localhost' -Key $registrationKey

Set-DscLocalConfigurationManager -Path .\ComplainceServerConfiguration -Verbose -Force
Start-DscConfiguration .\ComplainceServerConfiguration -Verbose -Force