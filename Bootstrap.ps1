Configuration Bootstrap
{
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    $DscModulePath = 'C:\Program Files\WindowsPowerShell\Modules'

    node localhost
    {
        File EndeavourWinDevFolder
		{
			Type = 'Directory'
			Force = $true
			DestinationPath = Join-Path $DscModulePath 'EndeavourWinDev'
		}

		File EndeavourWinDevDataFile
		{
			Type = 'File'
			Force = $true
			SourcePath = Join-Path $Path 'EndeavourWinDev.psd1'
			DestinationPath = Join-Path $DscModulePath 'EndeavourWinDev\EndeavourWinDev.psd1'
		}

		File EndeavourWinDevResources
		{
			Type = 'Directory'
			Recurse = $true
			Force = $true
			SourcePath = Join-Path $Path 'DSCResources'
			DestinationPath = Join-Path $DscModulePath 'EndeavourWinDev\DSCResources'
		}

		Script xWindowsUpdate 
		{
			GetScript = {
				return @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = Get-Package xWindowsUpdate -ErrorAction SilentlyContinue
                }
			}
			TestScript = {
				$installed = Get-Package xWindowsUpdate -ErrorAction SilentlyContinue
				return ($installed -ne $null)
			}
			SetScript = {
				Install-Package xWindowsUpdate
			}
		}
    }   
}

Bootstrap -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)
Start-DscConfiguration -Path .\Bootstrap -Wait -Force -Verbose