Param(
    [Hashtable]$parameters
)

# Fix for WinRM session instability in GitHub Actions
# Force BcContainerHelper to use docker exec instead of WinRM sessions
$bcContainerHelperConfig.useWinRmSession = "never"

New-BcContainer @parameters;
Invoke-ScriptInBcContainer $parameters.ContainerName -scriptblock { $progressPreference = 'SilentlyContinue' }
