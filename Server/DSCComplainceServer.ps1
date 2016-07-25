param
(
    [Parameter(Mandatory=$false)]
    [String] $NodeName = 'localhost',

    [Parameter(Mandatory)]
    [String] $Key
)

Configuration ComplainceServerConfiguration
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

        xDscWebService ComplainceServer  
        {
            Ensure                  = "Present" 
            EndpointName            = "ComplainceServer" 
            Port                    =  $Node.Port
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\ComplainceServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic" 
            State                   = "Started" 
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
                RegistrationKey = $Key
                RebootNodeifNeeded = $true
            }
        )
    }


ComplainceServerConfiguration -ConfigurationData $ConfigParameters