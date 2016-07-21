$DownloadUrl = 'http://www.sparxsystems.com.au/bin/EALite.exe'
$WindowsTemp = Join-Path $env:windir "temp"
$Path = Join-Path $WindowsTemp "Ealite.msi"

$exists = Test-Path $Path -ErrorAction SilentlyContinue
if($exists)
{
    Write-Output "$Path exists"
}
else {
    Write-Output "$Path does not exist"
}
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("$DownloadUrl", $Path)




Start-Process -FilePath $Path -ArgumentList "/quiet /norestart" -Wait
Remove-Item $Path -Force -ErrorAction SilentlyContinue
