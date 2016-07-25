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
            ConfigurationID = "1cd8a349-ff19-4ca4-94ae-3e3e1367a514";
        }

        ConfigurationRepositoryWeb ConfigurationManager
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/';
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc';
            AllowUnsecureConnection = $true; #This needs to be fixed in the future.;
            ConfigurationNames = @("WinDevBox","DemoPullClient");
        }  

        #ReportServerWeb EndeavourPullServer
        #{
        #    ServerURL       = 'http://52.174.151.121/psdscpullserver.svc/'
        #    RegistrationKey = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc'
        #    AllowUnsecureConnection = $true 
        #}
    }
}

PullClientConfiguration
Set-DscLocalConfigurationManager -Path .\PullClientConfiguration -Verbose -Force 