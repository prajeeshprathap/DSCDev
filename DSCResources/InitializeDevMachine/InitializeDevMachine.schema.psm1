Configuration InitializeDevMachine
{
    Import-DscResource -Name iChocoInstall
    node localhost
    {
        Registry DisableLUA
		{
			Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
			ValueName = "EnableLUA"
			ValueData = 1
			ValueType = "DWORD"
			Ensure = "Present"
		}

        iChocoInstall InstallChocolatey
		{
			InstallDir = "C:\ProgramData\chocolatey"
		}
    }
}