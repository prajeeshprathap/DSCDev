$Name = 'Enterprise Architect'

$uninstall32 = Get-ChildItem "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" `
                 |% { Get-ItemProperty $_.PSPath } `
                 |? {$_.DisplayName -like "$Name"} `
                 | Select UninstallString
$uninstall64 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" `
                 |% { Get-ItemProperty $_.PSPath } `
                 |? {$_.DisplayName -like "$Name"} `
                 | Select UninstallString

if ($uninstall64) 
{
    $uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
    $uninstall64 = $uninstall64.Trim()
    Start-Process "msiexec.exe" -arg "/X $uninstall64 /qn" -Wait
}
if ($uninstall32) 
{
    $uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
    $uninstall32 = $uninstall32.Trim()
    Start-Process "msiexec.exe" -arg "/X $uninstall32 /qn" -Wait
}