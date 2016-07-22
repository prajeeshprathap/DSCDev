[DSCLocalConfigurationManager()]
configuration PullClientConfiguration
{
    Node localhost
    {
        Settings
        {
            RefreshMode          = 'Pull'
            RefreshFrequencyMins = 30 
            RebootNodeIfNeeded   = $true
        }

        ConfigurationRepositoryWeb EndeavourPullServer
        {
            ServerURL          = 'http://52.174.151.121/psdscpullserver.svc/'
            RegistrationKey    = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc'
            ConfigurationNames = @('ClientConfig')
        }   

        ReportServerWeb EndeavourPullServer
        {
            ServerURL       = 'http://52.174.151.121/psdscpullserver.svc/'
            RegistrationKey = 'c944ce11-0ffe-467b-bb22-fd1cd2fd76bc'
        }
    }
}

PullClientConfiguration
Start-DscConfiguration .\PullClientConfiguration -Wait -Verbose