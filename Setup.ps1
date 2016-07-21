Configuration Setup
{
    Import-DscResource -Module EndeavourWinDev
    Import-DscResource -ModuleName xWindowsUpdate

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
            Ensure = 'Absent'
        }

        iChocoPackage HipChat
        {
            Name = 'hipchat'
            Ensure = 'Absent'
        }

        iChocoPackage VisualStudioCode
        {
            Name = 'visualstudiocode'
        }

        iChocoPackage VSCommunity
        {
            Name = 'visualstudio2015community'
            Ensure = 'Absent' 
        }

        #WindowsFeature DesktopExperience
        #{
        #    Name = 'Desktop-Experience'
        #    Ensure = 'Present'
        #    IncludeAllSubFeature = $true
        #}

        xWindowsUpdateAgent MuSecurityImportant
        {
            IsSingleInstance = 'Yes'
            UpdateNow        = $true
            Category         = @('Security','Important')
            Source           = 'MicrosoftUpdate'
            Notifications    = 'Disabled'
        }
    }
}

Setup
Start-DscConfiguration -Path .\Setup -Wait -Force -Verbose