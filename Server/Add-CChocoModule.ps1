Add-Type -A System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory('C:\Windows\System32\WindowsPowerShell\v1.0\Modules\CChoco', "$env:TEMP\CChoco_2.1.1.51.zip")

$moduleUploadFolder = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules\"
Move-Item -Path $env:TEMP\CChoco_2.1.1.51.zip -Destination $moduleUploadFolder

"Creating checksum" | Write-Host
New-DSCCheckSum -path $moduleUploadFolder -force