Configuration Setup
{
    Import-DscResource -Module EndeavourWinDev
    write-output 'done'

    node localhost
    {
        InitializeDevMachine Init
        {

        }
    }
}

Setup
Start-DscConfiguration -Path .\Setup -Wait -Force -Verbose