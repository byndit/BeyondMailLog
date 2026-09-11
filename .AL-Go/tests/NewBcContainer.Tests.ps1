BeforeAll {
    $hookPath = Join-Path $PSScriptRoot '../NewBcContainer.ps1'

    # BcContainerHelper is the external boundary; execute the real repository hook.
    function New-BcContainer {
        param($ContainerName, $accept_eula, $artifactUrl)
    }
    function Invoke-ScriptInBcContainer {
        param($ContainerName, $scriptblock)
    }
    function ConvertTo-HashTable {
        param([Parameter(ValueFromPipeline)] $InputObject)
        process {
            $result = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $result[$property.Name] = $property.Value
            }
            $result
        }
    }
}

Describe 'AL-only build container initialization' {
    BeforeEach {
        $originalSecrets = $env:Secrets
        $originalToken = $env:GITHUB_TOKEN
        $env:GITHUB_TOKEN = 'existing-workflow-token'
        $bcContainerHelperConfig = @{}
        $parameters = @{
            ContainerName = 'mail-log-test'
            accept_eula = $true
            artifactUrl = 'https://example.invalid/bc-artifact'
        }
        Mock New-BcContainer {}
        Mock Invoke-ScriptInBcContainer {}
    }

    AfterEach {
        $env:Secrets = $originalSecrets
        $env:GITHUB_TOKEN = $originalToken
    }

    It 'creates the container without package credentials: <Name>' -ForEach @(
        @{ Name = 'no secrets'; Secrets = $null }
        @{ Name = 'empty secrets'; Secrets = '{}' }
        @{ Name = 'empty package context'; Secrets = '{"gitHubPackagesContext":"e30="}' }
    ) {
        $env:Secrets = $Secrets
        & {
            $ErrorActionPreference = 'Stop'
            Set-StrictMode -Version 2.0
            . $hookPath -parameters $parameters
        }

        Should -Invoke New-BcContainer -Exactly 1 -ParameterFilter {
            $ContainerName -eq 'mail-log-test' -and $accept_eula -and
            $artifactUrl -eq 'https://example.invalid/bc-artifact'
        }
        Should -Invoke Invoke-ScriptInBcContainer -Exactly 1 -ParameterFilter {
            $ContainerName -eq 'mail-log-test'
        }
        $bcContainerHelperConfig.useWinRmSession | Should -Be 'never'
        $env:GITHUB_TOKEN | Should -Be 'existing-workflow-token'
    }

    It 'reports container creation failures without running container setup' {
        $env:Secrets = '{"gitHubPackagesContext":"e30="}'
        Mock New-BcContainer { throw 'Container creation failed' }

        {
            $ErrorActionPreference = 'Stop'
            Set-StrictMode -Version 2.0
            . $hookPath -parameters $parameters
        } | Should -Throw '*Container creation failed*'
        Should -Invoke Invoke-ScriptInBcContainer -Exactly 0
    }
}
