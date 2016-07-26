$ErrorActionPreference = 'Stop'
if((Get-ExecutionPolicy) -eq 'Restricted')
{
    throw 'Execution policy should be set atlease to RemoteSigned..'
}
if(-not(Test-WSMan -ErrorAction SilentlyContinue))
{
    Set-WSManQuickConfig -Force 
}

$configServerUrl = 'http://52.174.151.121/psdscpullserver.svc/'
$reportServerUrl = 'http://52.174.149.167/PSDSCPullServer.svc/'
$configServerKey = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc'
$reportServerKey = '62f25315-62f1-47eb-a091-fc1f7b70f40e'

.\ClientConfig.ps1 -ConfigurationServerUrl $configServerUrl `
                    $ModuleServerUrl $configServerUrl `
                    $ReportServerUrl $reportServerUrl `
                    $ConfigurationServerKey $configServerKey `
                    $ModuleServerKey $configServerKey `
                    $ReportServerKey $reportServerKey


Set-DscLocalConfigurationManager -Path .\PullClientConfiguration -Verbose -Force 