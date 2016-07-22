configuration DSCPullServerConfiguration
{
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration 

     Node localhost 
     { 
         WindowsFeature DSCServiceFeature 
         { 
             Ensure = 'Present'
             Name   = 'DSC-Service'             
         } 

         xDscWebService PSDSCPullServer 
         { 
             Ensure                  = 'Present' 
             EndpointName            = 'DSCPullServer' 
             Port                    = 8080
             PhysicalPath            = "$env:SystemDrive\inetpub\DSCPullServer" 
             CertificateThumbPrint   = 'AllowUnencryptedTraffic'       
             ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules" 
             ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration" 
             State                   = 'Started'
             DependsOn               = '[WindowsFeature]DSCServiceFeature'                         
         } 

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = "c944ce11-0ffe-467b-bb22-fd1cd2fd76bc"
        }
    }
}

DSCPullServerConfiguration
Start-DSCConfiguration -Path .\DSCPullServerConfiguration -Wait -Verbose