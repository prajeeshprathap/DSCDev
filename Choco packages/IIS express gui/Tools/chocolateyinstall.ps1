$arguments = @{}

# Let's assume that the input string is something like this, and we will use a Regular Expression to parse the values
# /Port:81 /Edition:LicenseKey /AdditionalTools

# Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
$packageParameters = $env:chocolateyPackageParameters

# Default the values
$path = 'C:\Tools\iisexpressgui'

# Now parse the packageParameters using good old regular expression
if ($packageParameters) 
{
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern )
    {
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | % {
        $arguments.Add(
            $_.Groups[$option_name].Value.Trim(),
            $_.Groups[$value_name].Value.Trim())
        }
    }
    else
    {
        Throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    if ($arguments.ContainsKey("Path")) 
    {
        $path = $arguments["Path"]
    } 
} 

Write-Verbose "IISExpress unzip location will be used as $path"

Install-ChocolateyZipPackage -PackageName 'iisexpressgui' -Url 'http://downloads.sourceforge.net/project/iisexpressgui/IISExpressGUIv1.0.zip?r=&ts=1469080716&use_mirror=master' -UnzipLocation $path