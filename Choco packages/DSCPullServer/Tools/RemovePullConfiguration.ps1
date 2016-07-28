param
(
    [Parameter(Mandatory=$false)]
    [String] $NodeName = 'localhost',

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [int] $Port
)

Configuration RemovePullConfiguration
{
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node $NodeName
    { 
        xDscWebService PullServer 
        { 
            Ensure                  = 'Absent';
            EndpointName            = 'PullServer';
            Port                    = $Node.Port;
            PhysicalPath            = "$env:SystemDrive\inetpub\PullServer";
            CertificateThumbPrint   = 'AllowUnencryptedTraffic';
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules";
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration";
            State                   = 'Started'                  
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Absent'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
        }

        WindowsFeature DSCServiceFeature 
        { 
            Ensure = 'Absent';
            Name   = 'DSC-Service'           
        } 
    }
}

$ConfigParameters = @{
    AllNodes = @(
            @{
                NodeName = 'localhost'
                Port = $Port
                RebootNodeifNeeded = $true
            }
        )
    }


RemovePullConfiguration -ConfigurationData $ConfigParameters