$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Network Watcher Parameter Validation" {

    Context "networkWatcherName Validation" {

        It "Has networkWatcherName parameter" {

            $json.parameters.networkWatcherName | should not be $null
        }

        It "networkWatcherName parameter is of type string" {

            $json.parameters.networkWatcherName.type | should be "string"
        }

        It "networkWatcherName parameter is mandatory" {

            ($json.parameters.networkWatcherName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "location Validation" {

        It "Has location parameter" {

            $json.parameters.location | should not be $null
        }

        It "location parameter is of type string" {

            $json.parameters.location.type | should be "string"
        }

        It "location parameter default value is [resourceGroup().location]" {

            $json.parameters.location.defaultValue | should be "[resourceGroup().location]"
        }

        It "location parameter allowed values are northeurope, westeurope" {

            (Compare-Object -ReferenceObject $json.parameters.location.allowedValues -DifferenceObject @("northeurope", "westeurope")).Length | should be 0
        }
    }

    Context "tags Validation" {

        It "Has tags parameter" {

            $json.parameters.tags | should not be $null
        }

        It "tags parameter is of type object" {

            $json.parameters.tags.type | should be "object"
        }

        It "tags parameter is mandatory" {

            ($json.parameters.tags.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Network Watcher Resource Validation" {

    $networkWatcher = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/networkWatchers" }

    Context "type Validation" {

        It "type value is Microsoft.Network/networkWatchers" {

            $networkWatcher.type | should be "Microsoft.Network/networkWatchers"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $networkWatcher.apiVersion | should be "2020-06-01"
        }
    }
}

Describe "Network Watcher Output Validation" {

    Context "Network Watcher Reference Validation" {

        It "type value is object" {

            $json.outputs.networkWatcher.type | should be "object"
        }

        It "Uses full reference for Network Watcher" {

            $json.outputs.networkWatcher.value | should be "[reference(resourceId('Microsoft.Network/networkWatchers', parameters('networkWatcherName')), '2020-06-01', 'Full')]"
        }
    }
}