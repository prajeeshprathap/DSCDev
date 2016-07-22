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
                    Result = (Get-Package xWindowsUpdate -ErrorAction SilentlyContinue) -ne $null
                }
			}
			TestScript = {
				$installed = Get-Package xWindowsUpdate -ErrorAction SilentlyContinue
				return ($installed -ne $null)
			}
			SetScript = {
				Install-Package xWindowsUpdate -Confirm$false
			}
		}

		Script AzureResourceManagerModule 
		{
			GetScript = {
				return @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = (Get-Command -Name Get-AzureRMResource -ErrorAction SilentlyContinue) -ne $null
                }
			}
			TestScript = {
				$installed =  Get-Command -Name Get-AzureRMResource -ErrorAction SilentlyContinue
				return ($installed -ne $null)
			}
			SetScript = {
				Install-Module AzureRM -Confirm:$false
				Install-Module Azure -Confirm:$false
			}
		}

		Script PSDesiredStateConfigurationModule 
		{
			GetScript = {
				return @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = (Get-Command -Name Get-xPSDesiredStateConfiguration -ErrorAction SilentlyContinue) -ne $null
                }
			}
			TestScript = {
				$installed =  Get-Command -Name xPSDesiredStateConfiguration -ErrorAction SilentlyContinue
				return ($installed -ne $null)
			}
			SetScript = {
				Install-Module xPSDesiredStateConfiguration -Confirm:$false
			}
		}
    }   
}

Bootstrap -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition)
Start-DscConfiguration -Path .\Bootstrap -Wait -Force -Verbose