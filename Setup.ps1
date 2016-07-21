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
            Source = 'http://endeavourchoco.azurewebsites.net/nuget'
        }

        iChocoPackage Pester
        {
            Name = 'Pester'
        }

        iChocoPackage NetFX40
        {
            Name = 'DotNet4.0'
        }

        iChocoPackage NetFX45
        {
            Name = 'DotNet4.5'
        }

        iChocoPackage AdobeDigitalEditions
        {
            Name = 'adobedigitaleditions'
        }

        iChocoPackage ILSpy
        {
            Name = 'ilspy'
        }

        iChocoPackage NCrunch
        {
            Name = 'ncrunch-vs2015'
        }

        iChocoPackage PickPick
        {
            Name = 'picpick.portable'
        }
    }
}

Setup
Start-DscConfiguration -Path .\Setup -Wait -Force -Verbose