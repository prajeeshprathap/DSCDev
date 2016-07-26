param
(
    [Parameter(Mandatory)]
    [string] $ConfigurationServerUrl,

    [Parameter(Mandatory)]
    [string] $ConfigurationServerKey,

    [Parameter(Mandatory)]
    [string] $ModuleServerUrl,

    [Parameter(Mandatory)]
    [string] $ModuleServerKey,

    [Parameter(Mandatory)]
    [string] $ReportServerUrl,

    [Parameter(Mandatory)]
    [string] $ReportServerKey
)

[DSCLocalConfigurationManager()]
configuration PullClientConfiguration
{
    node localhost
    {
        Settings
        {
            AllowModuleOverwrite = $True;
            ConfigurationMode = 'ApplyAndAutoCorrect';
            ConfigurationModeFrequencyMins = 60;
            RefreshMode          = 'Pull';
            RefreshFrequencyMins = 30 ;
            RebootNodeIfNeeded   = $true;
        }

        #specifies an HTTP pull server for configurations
        ConfigurationRepositoryWeb DSCConfigurationServer
        {
            ServerURL          = $Node.ConfigServer;
            RegistrationKey    = $Node.ConfigServerKey;
            AllowUnsecureConnection = $true;
            ConfigurationNames = @("BaseConfig", "ChocoConfig")
        }

        PartialConfiguration BaseConfig 
        {
            Description = "BaseConfig"
            ConfigurationSource = @("[ConfigurationRepositoryWeb]DSCConfigurationServer") 
        }

        PartialConfiguration ChocoConfig
        {
            Description = "ChocoConfig"
            ConfigurationSource = @("[ConfigurationRepositoryWeb]DSCConfigurationServer")
            DependsOn = '[PartialConfiguration]BaseConfig'
        }

        #specifies an HTTP pull server for modules
        ResourceRepositoryWeb DSCModuleServer
        {
            ServerURL          = $Node.ModuleServer;
            RegistrationKey    = $Node.$ModuleServerKey;
            AllowUnsecureConnection = $true;
        }

        #specifies an HTTP pull server to which reports are sent
        ReportServerWeb DSCComplainceServer
        {
            ServerURL          = $Node.ComplainceServer;
            RegistrationKey    = $Node.ComplainceServerKey;
            AllowUnsecureConnection = $true;
        }
    }
}

$configParams = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            ConfigServer = $ConfigurationServerUrl
            ConfigServerKey = $ConfigurationServerKey
            ModuleServer = $ModuleServerUrl
            ModuleServerKey = $ModuleServerKey
            ComplainceServer = $ReportServerUrl
            ComplainceServerKey = $ReportServerKey
        }
    )
}

PullClientConfiguration -ConfigurationData $configParams