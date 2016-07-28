

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
            RefreshMode          = 'Push';
            RefreshFrequencyMins = 60 ;
            RebootNodeIfNeeded   = $true;
        }
    }
}

PullClientConfiguration