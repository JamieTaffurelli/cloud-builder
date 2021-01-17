$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "VM Shutdown Schedule Parameter Validation" {

    Context "resourceSubscriptionId Validation" {

        It "Has resourceSubscriptionId parameter" {

            $json.parameters.resourceSubscriptionId | should not be $null
        }

        It "resourceSubscriptionId parameter is of type string" {

            $json.parameters.resourceSubscriptionId.type | should be "string"
        }

        It "resourceSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.resourceSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "resourceGroupName Validation" {

        It "Has resourceGroupName parameter" {

            $json.parameters.resourceGroupName | should not be $null
        }

        It "resourceGroupName parameter is of type string" {

            $json.parameters.resourceGroupName.type | should be "string"
        }

        It "resourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.resourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "resourceType Validation" {

        It "Has resourceType parameter" {

            $json.parameters.resourceType | should not be $null
        }

        It "resourceType parameter is of type string" {

            $json.parameters.resourceType.type | should be "string"
        }

        It "resourceType parameter default value is Microsoft.Compute/virtualMachines" {

            $json.parameters.resourceType.defaultValue | should be "Microsoft.Compute/virtualMachines"
        }
    }

    Context "resourceName Validation" {

        It "Has resourceName parameter" {

            $json.parameters.resourceName | should not be $null
        }

        It "resourceName parameter is of type string" {

            $json.parameters.resourceName.type | should be "string"
        }

        It "resourceName parameter is mandatory" {

            ($json.parameters.resourceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "status Validation" {

        It "Has status parameter" {

            $json.parameters.status | should not be $null
        }

        It "status parameter is of type string" {

            $json.parameters.status.type | should be "string"
        }

        It "status parameter default value is Enabled" {

            $json.parameters.status.defaultValue | should be "Enabled"
        }

        It "status parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.status.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "timeOfDay Validation" {

        It "Has timeOfDay parameter" {

            $json.parameters.timeOfDay | should not be $null
        }

        It "timeOfDay parameter is of type string" {

            $json.parameters.timeOfDay.type | should be "string"
        }

        It "timeOfDay parameter default value is 1900" {

            $json.parameters.timeOfDay.defaultValue | should be "1900"
        }
    }

    Context "timeZoneId Validation" {

        It "Has timeZoneId parameter" {

            $json.parameters.timeZoneId | should not be $null
        }

        It "timeZoneId parameter is of type string" {

            $json.parameters.timeZoneId.type | should be "string"
        }

        It "timeZoneId parameter default value is 1900" {

            $json.parameters.timeZoneId.defaultValue | should be "GMT Standard Time"
        }
    }

    Context "notificationSettings Validation" {

        It "Has notificationSettings parameter" {

            $json.parameters.notificationSettings | should not be $null
        }

        It "notificationSettings parameter is of type object" {

            $json.parameters.notificationSettings.type | should be "object"
        }

        It "notificationSettings parameter is an empty object" {

            $json.parameters.notificationSettings.defaultValue.PSObject.Properties.Name.Count | should be 0
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

Describe "VM Shutdown Schedule Resource Validation" {

    $schedule = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.DevTestLab/schedules" }

    Context "type Validation" {

        It "type value is Microsoft.DevTestLab/schedules" {

            $schedule.type | should be "Microsoft.DevTestLab/schedules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-09-15" {

            $schedule.apiVersion | should be "2018-09-15"
        }
    }

    Context "taskType Validation" {

        It "taskType value is ComputeVmShutdownTask" {

            $schedule.properties.taskType | should be "ComputeVmShutdownTask"
        }
    }
}

Describe "VM Shutdown Schedule Validation" {

    Context "VM Shutdown Schedule Reference Validation" {

        It "type value is object" {

            $json.outputs.schedule.type | should be "object"
        }

        It "Uses full reference for Schedule" {

            $json.outputs.schedule.value | should be "[reference(resourceId('Microsoft.DevTestLab/schedules', variables('scheduleName')), '2018-09-15', 'Full')]"
        }
    }
}