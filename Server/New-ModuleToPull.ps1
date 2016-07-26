$parentFolder = Split-Path -Parent (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)
$testModulePath = Join-Path $parentFolder 'Modules\xDismFeature'

"Compressing the module xTestResource to $env:TEMP\xDismFeature_1.0.zip" | Write-Host
Add-Type -A System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($testModulePath, "$env:TEMP\xDismFeature_1.0.zip")


$moduleUploadFolder = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules\"
"Moving the compressed folder to module share location $moduleUploadFolder" | Write-Host
Move-Item -Path $env:TEMP\xDismFeature_1.0.zip -Destination "$moduleUploadFolder"

"Creating checksum" | Write-Host
New-DSCCheckSum -path $moduleUploadFolder -force