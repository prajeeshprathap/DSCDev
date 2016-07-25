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
            DebugMode = $true;
        }

        #specifies an HTTP pull server for configurations
        ConfigurationRepositoryWeb DSCConfigurationServer
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/';
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc';
            AllowUnsecureConnection = $true;
            ConfigurationNames = @("WindowsDevMachine")
        }

        #specifies an HTTP pull server for modules
        ResourceRepositoryWeb DSCModuleServer
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/';
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc';
            AllowUnsecureConnection = $true;
        }

        #specifies an HTTP pull server to which reports are sent
        ReportServerWeb DSCComplainceServer
        {
            ServerURL          = 'http://52.174.149.167/psdscpullserver.svc/';
            RegistrationKey    = '62f25315-62f1-47eb-a091-fc1f7b70f40e';
            AllowUnsecureConnection = $true;
        }
    }
}

PullClientConfiguration
Set-DscLocalConfigurationManager -Path .\PullClientConfiguration -Verbose -Force 