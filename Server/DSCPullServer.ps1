configuration DSCPullServerConfiguration
{
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration 

     Node $Computer 
     { 
        WindowsFeature DSCServiceFeature 
        { 
            Ensure = 'Present'
            Name   = 'DSC-Service'             
        } 

        #Needed from complaince server
        WindowsFeature WebWindowsAuth 
        {
            Ensure = "Present"
            Name   = "web-Windows-Auth"
            Dependson = "[WindowsFeature]DSCServiceFeature"
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
         
        #xDscWebService PSDSCComplianceServer  
        #{
        #   Ensure                  = "Present" 
        #   EndpointName            = "PSDSCComplianceServer" 
        #   Port                    =  9080
        #   PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
        #   CertificateThumbPrint   = "AllowUnencryptedTraffic" 
        #   State                   = "Started" 
        #   IsComplianceServer      = $true 
        #   DependsOn               = @("[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer")  
        #}

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

$ConfigParameters = @{
    Path = ".\DSCPullServerConfiguration"
    Computer = 'localhost'
    Wait = $True
    Verbose = $True
    Force = $True
}

Start-DSCConfiguration $ConfigParameters  