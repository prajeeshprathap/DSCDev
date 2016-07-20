Configuration Setup
{
    Import-DscResource -Module EndeavourWinDev
    write-output 'done'

    node localhost
    {
        InitializeDevMachine Init
        {

        }

        iChocoPackage 7Zip
        {
            Name = '7zip.install'
        }

        iChocoPackage IISExpressGui
        {
            Name = 'iisexpressgui'
            Source = 'http://localhost:8085/nuget'
        }
    }
}

Setup
Start-DscConfiguration -Path .\Setup -Wait -Force -Verbose