$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Container Group Parameter Validation" {

    Context "containerGroupName Validation" {

        It "Has containerGroupName parameter" {

            $json.parameters.containerGroupName | should not be $null
        }

        It "containerGroupName parameter is of type string" {

            $json.parameters.containerGroupName.type | should be "string"
        }

        It "containerGroupName parameter is mandatory" {

            ($json.parameters.containerGroupName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "sku Validation" {

        It "Has sku parameter" {

            $json.parameters.sku | should not be $null
        }

        It "sku parameter is of type string" {

            $json.parameters.sku.type | should be "string"
        }

        It "sku parameter default value is Standard" {

            $json.parameters.sku.defaultValue | should be "Standard"
        }

        It "sku parameter allowed values are Standard, Dedicated" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Standard", "Dedicated")).Length | should be 0
        }
    }

    Context "containers Validation" {

        It "Has containers parameter" {

            $json.parameters.containers | should not be $null
        }

        It "containers parameter is of type array" {

            $json.parameters.containers.type | should be "array"
        }

        It "containers parameter is mandatory" {

            ($json.parameters.containers.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "imageRegistryCredentials Validation" {

        It "Has imageRegistryCredentials parameter" {

            $json.parameters.imageRegistryCredentials | should not be $null
        }

        It "imageRegistryCredentials parameter is of type secureObject" {

            $json.parameters.imageRegistryCredentials.type | should be "secureObject"
        }

        It "imageRegistryCredentials parameter default value is an empty object" {

            $json.parameters.imageRegistryCredentials.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "restartPolicy Validation" {

        It "Has restartPolicy parameter" {

            $json.parameters.restartPolicy | should not be $null
        }

        It "restartPolicy parameter is of type string" {

            $json.parameters.restartPolicy.type | should be "string"
        }

        It "restartPolicy parameter default value is OnFailure" {

            $json.parameters.restartPolicy.defaultValue | should be "OnFailure"
        }

        It "restartPolicy parameter allowed values are Always, OnFailure, Never" {

            (Compare-Object -ReferenceObject $json.parameters.restartPolicy.allowedValues -DifferenceObject @("Always", "OnFailure", "Never")).Length | should be 0
        }
    }

    Context "osType Validation" {

        It "Has osType parameter" {

            $json.parameters.osType | should not be $null
        }

        It "osType parameter is of type string" {

            $json.parameters.osType.type | should be "string"
        }

        It "osType parameter default value is Linux" {

            $json.parameters.osType.defaultValue | should be "Linux"
        }

        It "osType parameter allowed values are Windows, Linux" {

            (Compare-Object -ReferenceObject $json.parameters.osType.allowedValues -DifferenceObject @("Windows", "Linux")).Length | should be 0
        }
    }

    Context "volumes Validation" {

        It "Has volumes parameter" {

            $json.parameters.volumes | should not be $null
        }

        It "volumes parameter is of type secureObject" {

            $json.parameters.volumes.type | should be "secureObject"
        }

        It "volumes parameter default value is an object with array property" {

            $json.parameters.volumes.defaultValue.array | should be @()
        }
    }

    Context "logAnalyticsId Validation" {

        It "Has logAnalyticsId parameter" {

            $json.parameters.logAnalyticsId | should not be $null
        }

        It "logAnalyticsId parameter is of type string" {

            $json.parameters.logAnalyticsId.type | should be "string"
        }

        It "logAnalyticsId parameter is mandatory" {

            ($json.parameters.logAnalyticsId.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "logAnalyticsWorkspaceKey Validation" {

        It "Has logAnalyticsWorkspaceKey parameter" {

            $json.parameters.logAnalyticsWorkspaceKey | should not be $null
        }

        It "logAnalyticsWorkspaceKey parameter is of type secureString" {

            $json.parameters.logAnalyticsWorkspaceKey.type | should be "secureString"
        }

        It "logAnalyticsWorkspaceKey parameter is mandatory" {

            ($json.parameters.logAnalyticsWorkspaceKey.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "initContainers Validation" {

        It "Has initContainers parameter" {

            $json.parameters.initContainers | should not be $null
        }

        It "initContainers parameter is of type array" {

            $json.parameters.initContainers.type | should be "array"
        }

        It "initContainers parameter default value is an empty array" {

            $json.parameters.initContainers.defaultValue | should be @()
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

Describe "Container Group Resource Validation" {

    $containerGroup = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ContainerInstance/containerGroups" }

    Context "type Validation" {

        It "type value is Microsoft.ContainerInstance/containerGroups" {

            $containerGroup.type | should be "Microsoft.ContainerInstance/containerGroups"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-12-01" {

            $containerGroup.apiVersion | should be "2019-12-01"
        }
    }
}

Describe "Container Group Output Validation" {

    Context "Container Group Reference Validation" {

        It "type value is object" {

            $json.outputs.containerGroup.type | should be "object"
        }

        It "Uses full reference for Container Group" {

            $json.outputs.containerGroup.value | should be "[reference(resourceId('Microsoft.ContainerInstance/containerGroups', parameters('containerGroupName')), '2019-12-01', 'Full')]"
        }
    }
}