$parentFolder = Split-Path -Parent (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)
$chocoModulePath = Join-Path $parentFolder 'DSCResources\iChocoPackage'

"Compressing the module iChocoPackage to $env:TEMP\iChocoPackage_1.0.zip" | Write-Host
Add-Type -A System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($chocoModulePath, "$env:TEMP\iChocoPackage_1.0.zip")


$moduleUploadFolder = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules\"
"Moving the compressed folder to module share location $moduleUploadFolder" | Write-Host
Move-Item -Path $env:TEMP\iChocoPackage_1.0.zip -Destination "$moduleUploadFolder"

"Creating checksum" | Write-Host
New-DSCCheckSum -path $moduleUploadFolder -force