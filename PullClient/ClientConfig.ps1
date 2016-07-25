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
            RefreshFrequencyMins = 15 ;
            RebootNodeIfNeeded   = $true;
        }

        ConfigurationRepositoryWeb ConfigurationManager
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/';
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc';
            AllowUnsecureConnection = $true; #This needs to be fixed in the future.;
            ConfigurationNames = @("WinDevBox","CanaryDemo01");
        }  
    }
}

PullClientConfiguration
Set-DscLocalConfigurationManager -Path .\PullClientConfiguration -Verbose -Force 