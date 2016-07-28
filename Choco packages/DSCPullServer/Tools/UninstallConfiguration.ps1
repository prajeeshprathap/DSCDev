param
(
    [Parameter(Mandatory=$false)]
    [String] $NodeName = 'localhost',

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [int] $PullServerPort,

    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [int] $ReportServerPort
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
            Port                    = $Node.PullServerPort;
            PhysicalPath            = "$env:SystemDrive\inetpub\PullServer";
            CertificateThumbPrint   = 'AllowUnencryptedTraffic';
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules";
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration";
            State                   = 'Started'                  
        }

        xDscWebService ReportServer  
        {
            Ensure                  = "Absent" 
            EndpointName            = "ReportServer" 
            Port                    =  $Node.ReportServerPort
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\ReportServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic" 
            State                   = "Started" 
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
                PullServerPort = $PullServerPort
                ReportServerPort = $ReportServerPort
                RebootNodeifNeeded = $true
            }
        )
    }


RemovePullConfiguration -ConfigurationData $ConfigParameters