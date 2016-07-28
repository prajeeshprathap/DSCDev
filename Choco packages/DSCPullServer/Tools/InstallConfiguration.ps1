param
(
    [Parameter(Mandatory=$false)]
    [String] $NodeName = 'localhost',

    [Parameter(Mandatory)]
    [String] $Key,

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [int] $PullServerPort,

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [int] $ReportServerPort,

    [Parameter(Mandatory=$false)]
    [string] $Thumbprint
)

Configuration PullServerConfiguration
{
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration 

    Node $NodeName
    { 
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RefreshMode = 'Push'
            RebootNodeifNeeded = $node.RebootNodeifNeeded
        }

        WindowsFeature DSCServiceFeature 
        { 
            Ensure = 'Present';
            Name   = 'DSC-Service'           
        } 

        if([string]::IsNullOrWhiteSpace($Node.CertificateThumbPrint))
        {
            xDscWebService PullServer 
            { 
                Ensure                  = 'Present';
                EndpointName            = 'PullServer';
                Port                    = $Node.PullServerPort;
                PhysicalPath            = "$env:SystemDrive\inetpub\PullServer";
                CertificateThumbPrint   = 'AllowUnencryptedTraffic';
                ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules";
                ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration";
                State                   = 'Started'
                DependsOn               = '[WindowsFeature]DSCServiceFeature'                         
            }

            xDscWebService ReportServer  
            {
                Ensure                  = "Present" 
                EndpointName            = "ReportServer" 
                Port                    =  $Node.ReportServerPort
                PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\ReportServer"
                CertificateThumbPrint   = "AllowUnencryptedTraffic" 
                State                   = "Started" 
            }
        }
        else
        {
            xDscWebService PullServer 
            { 
                Ensure                  = 'Present';
                EndpointName            = 'PullServer';
                Port                    = $Node.PullServerPort;
                PhysicalPath            = "$env:SystemDrive\inetpub\PullServer";
                CertificateThumbPrint   = $Node.CertificateThumbPrint;
                ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules";
                ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration";
                State                   = 'Started'
                DependsOn               = '[WindowsFeature]DSCServiceFeature'                         
            }

            xDscWebService ReportServer  
            {
                Ensure                  = "Present" 
                EndpointName            = "ReportServer" 
                Port                    =  $Node.ReportServerPort
                PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\ReportServer"
                CertificateThumbPrint   = $Node.CertificateThumbPrint;
                State                   = "Started" 
            }
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $Node.RegistrationKey
        }
    }
}

$ConfigParameters = @{
    AllNodes = @(
            @{
                NodeName = 'localhost'
                PullServerPort = $PullServerPort
                ReportServerPort = $ReportServerPort
                CertificateThumbPrint = $Thumbprint
                RegistrationKey = $Key
                RebootNodeifNeeded = $true
            }
        )
    }

PullServerConfiguration -ConfigurationData $ConfigParameters