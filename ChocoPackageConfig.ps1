param
(
    [Parameter(Mandatory)]
    [string] $Path
)

configuration ChocoPackageConfiguration
{
    Import-DscResource -Module CChoco

    Node localhost
    {	
		cChocoInstaller InstallChocolatey
        {
            InstallDir = "C:\ProgramData\chocolatey"
        }

        cChocoPackageInstaller 7Zip
        {
            Name = '7zip.install'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller IISExpressGui
        {
            Name = 'iisexpressgui'
            Source = 'http://endeavourchoco.azurewebsites.net/nuget'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller Pester
        {
            Name = 'Pester'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller NetFX40
        {
            Name = 'DotNet4.0'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller NetFX45
        {
            Name = 'DotNet4.5'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller AdobeDigitalEditions
        {
            Name = 'adobedigitaleditions'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller AdobeReaderDC
        {
            Name = 'adobereader'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller EnterpriseArchitectLite
        {
            Name = 'ealite'
            Version = '1.1.4'
            Source = 'http://endeavourchoco.azurewebsites.net/nuget'
            Ensure = 'Absent'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller ILSpy
        {
            Name = 'ilspy'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller NCrunch
        {
            Name = 'ncrunch-vs2015'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller PickPick
        {
            Name = 'picpick.portable'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller NotePadPlusPlus
        {
            Name = 'notepadplusplus'
            Ensure = 'Absent'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller HipChat
        {
            Name = 'hipchat'
            Ensure = 'Absent'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller VisualStudioCode
        {
            Name = 'visualstudiocode'
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller VSCommunity
        {
            Name = 'visualstudio2015community'
            Ensure = 'Absent' 
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }

        cChocoPackageInstaller SystemCenter2012EndpointProtection
        {
            Name = 'scep'
            Source = 'http://endeavourchoco.azurewebsites.net/nuget'
            Ensure = 'Absent' 
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }
    }
}

ChocoPackageConfiguration -OutputPath $Path