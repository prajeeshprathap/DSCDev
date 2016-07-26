$parentFolder = Split-Path -Parent (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)
$testModulePath = Join-Path $parentFolder 'Modules\CChoco'

"Compressing the module xDismFeature to $env:TEMP\CChoco_2.1.1.51.zip" | Write-Host
Add-Type -A System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($testModulePath, "$env:TEMP\CChoco_2.1.1.51.zip")


$moduleUploadFolder = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules\"
"Moving the compressed folder to module share location $moduleUploadFolder" | Write-Host
Move-Item -Path $env:TEMP\CChoco_2.1.1.51.zip -Destination "$moduleUploadFolder"

"Creating checksum" | Write-Host
New-DSCCheckSum -path $moduleUploadFolder -force