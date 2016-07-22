Describe "Validate machine is in desired state after applying the configuration" {
    It "Should have applied DSC configuration"{
        Get-DscConfigurationStatus | select -expand Status | Should BeExactly "Success"
    }
    
    It "LCM settings are applied correctly"{
        Get-DscLocalConfigurationManager | select -expand refreshmode | Should BeLike "Push"
    }
    
    It "Base DSCResources are copied to Module path"{
        Get-DscResource -Module EndeavourWinDev |? {$_.Name -eq "iChocoInstall" } | select -ExpandProperty Name | Should BeExactly "iChocoInstall"
        Get-DscResource -Module EndeavourWinDev |? {$_.Name -eq "iChocoPackage" } | select -ExpandProperty Name | Should BeExactly "iChocoPackage"
        Get-DscResource -Module EndeavourWinDev |? {$_.Name -eq "InitializeDevMachine" } | select -ExpandProperty Name | Should BeExactly "InitializeDevMachine"
    }

    It "xWindowsUpdate package is installed from PowerShell Gallery"{
        Get-Package xWindowsUpdate | select -expand Version | Should BeLike "2.5*"
    }

    It "User account control should be disabled"{
        $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
        (Get-ItemProperty -Path $key).EnableLUA | Should Be 1
    }

    It "Chocolatey is installed and available on the machine"{
        Test-Path "C:\ProgramData\chocolatey\bin\choco.exe" -ErrorAction SilentlyContinue | Should Be $true
    }
    
    $installedPackages = choco list -lo

    It "Automatically installs Visual Studio Code" {
        $installedPackages |? {$_ -like "visualstudiocode*"} | Should Match "visualstudiocode"
    }
    It "Automatically installs Visual Studio 2015" {
        $installedPackages |? {$_ -like "vs2015*"} | Should BeNullOrEmpty
    }
    It "Automatically installs Enterprise Architect Lite" {
        $installedPackages |? {$_ -like "ealite*"} | Should BeNullOrEmpty
    }
    It "Automatically installs IL Spy" {
        $installedPackages |? {$_ -like "ilspy*"} | Should Match "ilspy"
    }
    It "7Zip should be installed" {
        $installedPackages |? {$_ -like "7Zip*"} | Should Match "7Zip"
    }
    It "Automatically installs Adobe digital editions" {
        $installedPackages |? {$_ -like "adobedigitaleditions*"} | Should Match "adobedigitaleditions"
    }
    It "Automatically installs Adobe Reader DC" {
        $installedPackages |? {$_ -like "adobereader*"} | Should Match "adobereader"
    }
    It "Automatically installs Auto hot key" {
        $installedPackages |? {$_ -like "autohotkey.portable*"} | Should Match "autohotkey.portable"
    }
    It "Automatically installs Beyond Compare" {
        $installedPackages |? {$_ -like "beyondcompare*"} | Should Match "beyondcompare"
    }
    It "Automatically installs Chef DK" {
        $installedPackages |? {$_ -like "chefdk*"} | Should Match "chefdk"
    }
    It "Automatically installs Con EMU" {
        $installedPackages |? {$_ -like "ConEmu*"} | Should Match "ConEmu"
    }
    It "Automatically installs DotNet4.0" {
        $installedPackages |? {$_ -like "DotNet4.0*"} | Should Match "DotNet4.0"
    }
    It "Automatically installs DotNet4.5" {
        $installedPackages |? {$_ -like "DotNet4.5*"} | Should Match "DotNet4.5"
    }
    It "Automatically installs fiddler" {
        $installedPackages |? {$_ -like "fiddler*"} | Should Match "fiddler"
    }
    It "Automatically installs PicPick" {
        $installedPackages |? {$_ -like "picpick.portable*"} | Should Match "picpick.portable"
    }
}