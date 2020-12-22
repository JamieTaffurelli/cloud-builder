$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Agent Pool Parameter Validation" {

    Context "poolName Validation" {

        It "Has poolName parameter" {

            $json.parameters.poolName | should not be $null
        }

        It "poolName parameter is of type string" {

            $json.parameters.poolName.type | should be "string"
        }

        It "poolName parameter is mandatory" {

            ($json.parameters.poolName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "clusterName Validation" {

        It "Has clusterName parameter" {

            $json.parameters.clusterName | should not be $null
        }

        It "clusterName parameter is of type string" {

            $json.parameters.clusterName.type | should be "string"
        }

        It "clusterName parameter is mandatory" {

            ($json.parameters.clusterName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "count Validation" {

        It "Has count parameter" {

            $json.parameters.count | should not be $null
        }

        It "count parameter is of type int" {

            $json.parameters.count.type | should be "int"
        }

        It "count parameter default value is 1" {

            $json.parameters.count.defaultValue | should be 1
        }
    }

    Context "vmSize Validation" {

        It "Has vmSize parameter" {

            $json.parameters.vmSize | should not be $null
        }

        It "vmSize parameter is of type string" {

            $json.parameters.vmSize.type | should be "string"
        }

        It "vmSize parameter default value is Standard_B2S" {

            $json.parameters.vmSize.defaultValue | should be "Standard_B2S"
        }
    }

    Context "osDiskSizeGB Validation" {

        It "Has osDiskSizeGB parameter" {

            $json.parameters.osDiskSizeGB | should not be $null
        }

        It "osDiskSizeGB parameter is of type int" {

            $json.parameters.osDiskSizeGB.type | should be "int"
        }

        It "osDiskSizeGB parameter default value is 32" {

            $json.parameters.osDiskSizeGB.defaultValue | should be 32
        }

        It "osDiskSizeGB parameter minimum value is 127" {

            $json.parameters.osDiskSizeGB.minValue | should be 32
        }

        It "osDiskSizeGB parameter maximum value is 2048" {

            $json.parameters.osDiskSizeGB.maxValue | should be 2048
        }
    }

    Context "maxPods Validation" {

        It "Has maxPods parameter" {

            $json.parameters.maxPods | should not be $null
        }

        It "maxPods parameter is of type int" {

            $json.parameters.maxPods.type | should be "int"
        }

        It "maxPods parameter default value is 30" {

            $json.parameters.maxPods.defaultValue | should be 30
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

    Context "maxCount Validation" {

        It "Has maxCount parameter" {

            $json.parameters.maxCount | should not be $null
        }

        It "maxCount parameter is of type int" {

            $json.parameters.maxCount.type | should be "int"
        }

        It "maxCount parameter default value is 1" {

            $json.parameters.maxCount.defaultValue | should be 1
        }
    }

    Context "minCount Validation" {

        It "Has minCount parameter" {

            $json.parameters.minCount | should not be $null
        }

        It "minCount parameter is of type int" {

            $json.parameters.minCount.type | should be "int"
        }

        It "minCount parameter default value is 1" {

            $json.parameters.minCount.defaultValue | should be 1
        }
    }

    Context "mode Validation" {

        It "Has mode parameter" {

            $json.parameters.mode | should not be $null
        }

        It "mode parameter is of type string" {

            $json.parameters.mode.type | should be "string"
        }

        It "mode parameter default value is User" {

            $json.parameters.mode.defaultValue | should be "User"
        }

        It "mode parameter allowed values are User, System" {

            (Compare-Object -ReferenceObject $json.parameters.mode.allowedValues -DifferenceObject @("User", "System")).Length | should be 0
        }
    }

    Context "maxSurge Validation" {

        It "Has maxSurge parameter" {

            $json.parameters.maxSurge | should not be $null
        }

        It "maxSurge parameter is of type string" {

            $json.parameters.maxSurge.type | should be "string"
        }

        It "maxSurge parameter default value is an empty string" {

            $json.parameters.maxSurge.defaultValue | should be ([String]::Empty)
        }
    }

    Context "availabilityZones Validation" {

        It "Has availabilityZones parameter" {

            $json.parameters.availabilityZones | should not be $null
        }

        It "availabilityZones parameter is of type array" {

            $json.parameters.availabilityZones.type | should be "array"
        }

        It "availabilityZones parameter default value is an empty array" {

            $json.parameters.availabilityZones.defaultValue | should be @()
        }
    }

    Context "enableNodePublicIP Validation" {

        It "Has enableNodePublicIP parameter" {

            $json.parameters.enableNodePublicIP | should not be $null
        }

        It "enableNodePublicIP parameter is of type bool" {

            $json.parameters.enableNodePublicIP.type | should be "bool"
        }

        It "enableNodePublicIP parameter default value is false" {

            $json.parameters.enableNodePublicIP.defaultValue | should be $false
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

    Context "nodeLabels Validation" {

        It "Has nodeLabels parameter" {

            $json.parameters.nodeLabels | should not be $null
        }

        It "nodeLabels parameter is of type object" {

            $json.parameters.nodeLabels.type | should be "object"
        }

        It "nodeLabels parameter default value is an empty object" {

            $json.parameters.nodeLabels.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "nodeTaints Validation" {

        It "Has nodeTaints parameter" {

            $json.parameters.nodeTaints | should not be $null
        }

        It "nodeTaints parameter is of type array" {

            $json.parameters.nodeTaints.type | should be "array"
        }

        It "nodeTaints parameter default value is an empty array" {

            $json.parameters.nodeTaints.defaultValue | should be @()
        }
    }
}

Describe "Agent Pool Resource Validation" {

    $agentPool = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ContainerService/managedClusters/agentPools" }

    Context "type Validation" {

        It "type value is Microsoft.ContainerService/managedClusters/agentPools" {

            $agentPool.type | should be "Microsoft.ContainerService/managedClusters/agentPools"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-11-01" {

            $agentPool.apiVersion | should be "2020-11-01"
        }
    }
}

Describe "Agent Pool Validation" {

    Context "Agent Pool Reference Validation" {

        It "type value is object" {

            $json.outputs.agentPool.type | should be "object"
        }

        It "Uses full reference for Schedule" {

            $json.outputs.agentPool.value | should be "[reference(resourceId('Microsoft.ContainerService/managedClusters/agentPools', parameters('clusterName'), parameters('poolName')), '2020-11-01', 'Full')]"
        }
    }
}