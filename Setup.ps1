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
    }
}

Setup
Start-DscConfiguration -Path .\Setup -Wait -Force -Verbose