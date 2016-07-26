param
(
    [Parameter(Mandatory)]
    [string] $Path
)

configuration BaseModuleConfiguration
{
    Node BaseConfig
    {	
		Registry DisableLUA
		{
			Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
			ValueName = "EnableLUA"
			ValueData = 1
			ValueType = "DWORD"
			Ensure = "Present"
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

		Script CChocoModule 
		{
			GetScript = {
				return @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = (Get-Module -ListAvailable -Name cChoco -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) -ne $null
                }
			}
			TestScript = {
				return (Get-Module -ListAvailable -Name cChoco -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) -ne $null
			}
			SetScript = {
				Install-Module cChoco -Force
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
    }
}

BaseModuleConfiguration -OutputPath $Path