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

        iChocoPackage AdobeReaderDC
        {
            Name = 'adobereader'
        }

        iChocoPackage EnterpriseArchitectLite
        {
            Name = 'ealite'
            Source = 'http://endeavourchoco.azurewebsites.net/nuget'
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

        iChocoPackage NotePadPlusPlus
        {
            Name = 'notepadplusplus'
        }

        iChocoPackage HipChat
        {
            Name = 'hipchat'
        }

        #WindowsFeature DesktopExperience
        #{
        #    Name = 'Desktop-Experience'
        #    Ensure = 'Present'
        #    IncludeAllSubFeature = $true
        #}
    }
}

Setup
Start-DscConfiguration -Path .\Setup -Wait -Force -Verbose