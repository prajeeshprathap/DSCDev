$sharefolder = 

function Extract-IISExpressGui($target)
{
    $source = '\\prajeeshp01\Choco\iisexpressgui\IISExpressGUIv1.0.zip'
    Add-Type -assembly 'system.io.compression.filesystem'
    [io.compression.zipfile]::ExtractToDirectory($source, $target)
    
    return $true
}

$ErrorActionPreference = 'Stop'; # stop on all errors
$success = Extract-IISExpressGui -target "C:\Tools\iisexpressgui"
if($success)
{
    Write-ChocolateySuccess 'iisexpressgui'
}
else {
    Write-ChocolateyFailure 'iisexpressgui'
}