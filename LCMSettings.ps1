[DscLocalConfigurationManager()]
configuration LCMSettings 
{
    node localhost 
	{
		settings 
		{
			RefreshMode = "PUSH"
			ConfigurationMode = "ApplyAndAutoCorrect"
			RebootNodeIfNeeded = $true
		}
    }
}

LCMSettings
Set-DscLocalConfigurationManager -Path .\LCMSettings -Verbose