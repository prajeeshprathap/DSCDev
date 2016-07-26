$tempConfigPath = Join-Path $env:TEMP "DemoConfiguration"
if(-not(Test-Path $tempConfigPath -ErrorAction SilentlyContinue)){
    New-Item -ItemType Directory -Force $tempConfigPath
}
.\DemoConfiguration -Path $tempConfigPath
$configurationFolder = Join-Path $tempConfigPath 'WindowsDevMachineConfiguration'

"Creating checksum file at location $configurationFolder" | Write-Host
New-DscChecksum -ConfigurationPath $configurationFolder -OutPath $configurationFolder -Verbose -Force


$configUploadFolder = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\"
"Copying the configuration and checksum files to $configUploadFolder" | Write-Host
Copy-Item -Path "$configurationFolder\*" -Destination $configUploadFolder