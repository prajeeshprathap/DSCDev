configuration WindowsDevMachineConfiguration
{
    node WindowsDevMachine
    {
        File TestFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:windir\Temp\DSCPullTest_ConfigName.txt"
            Contents        = "The demo works if you see this"
        }
    }
}

WindowsDevMachineConfiguration