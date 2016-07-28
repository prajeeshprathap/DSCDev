param
(
    [Parameter(Mandatory=$false)]
    [String] $NodeName = 'localhost',

    [Parameter(Mandatory)]
    [String] $Key,

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [int] $Port
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

        xDscWebService PullServer 
        { 
            Ensure                  = 'Present';
            EndpointName            = 'PullServer';
            Port                    = $Node.Port;
            PhysicalPath            = "$env:SystemDrive\inetpub\PullServer";
            CertificateThumbPrint   = 'AllowUnencryptedTraffic';
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules";
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration";
            State                   = 'Started'
            DependsOn               = '[WindowsFeature]DSCServiceFeature'                         
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
                Port = $Port
                RegistrationKey = $Key
                RebootNodeifNeeded = $true
            }
        )
    }

PullServerConfiguration -ConfigurationData $ConfigParameters