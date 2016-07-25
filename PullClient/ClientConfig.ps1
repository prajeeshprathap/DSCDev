[DSCLocalConfigurationManager()]
configuration PullClientConfiguration
{
    node localhost
    {
        Settings
        {
            AllowModuleOverwrite = $True;
            ConfigurationMode = 'ApplyAndAutoCorrect';
            ConfigurationModeFrequencyMins = 60;
            RefreshMode          = 'Pull';
            RefreshFrequencyMins = 30 ;
            RebootNodeIfNeeded   = $true;
            #ConfigurationID = '1cd8a349-ff19-4ca4-94ae-3e3e1367a514'
        }

        #specifies an HTTP pull server for configurations
        ConfigurationRepositoryWeb DSCConfigurationServer
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/';
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc';
            AllowUnsecureConnection = $true; #This needs to be fixed in the future.;
            ConfigurationNames = @("WindowsDevMachine")
        }

        #specifies an HTTP pull server for modules
        ResourceRepositoryWeb DSCModuleServer
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/';
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc';
            AllowUnsecureConnection = $true; #This needs to be fixed in the future.;
        }

        #specifies an HTTP pull server to which reports are sent
        ReportServerWeb DSCComplainceServer
        {
            ServerURL          = 'http://52.174.149.167/psdscpullserver.svc/';
            RegistrationKey    = '62f25315-62f1-47eb-a091-fc1f7b70f40e';
            AllowUnsecureConnection = $true; #This needs to be fixed in the future.;
        }
    }
}

PullClientConfiguration
Set-DscLocalConfigurationManager -Path .\PullClientConfiguration -Verbose -Force 