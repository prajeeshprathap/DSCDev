param
(
    [Parameter(Mandatory=$false)]
    [String] $NodeName = 'localhost'
)

Configuration PullServerConfiguration
{
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration 

    Node $NodeName
    { 
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyAndAutoCorrect'
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
                Port = 8080
                RegistrationKey = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc'
                RebootNodeifNeeded = $true
            }
        )
    }


PullServerConfiguration -ConfigurationData $ConfigParameters