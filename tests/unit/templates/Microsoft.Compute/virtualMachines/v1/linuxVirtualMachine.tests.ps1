$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Linux Virtual Machine Parameter Validation" {

    Context "vmName Validation" {

        It "Has vmName parameter" {

            $json.parameters.vmName | should not be $null
        }

        It "vmName parameter is of type string" {

            $json.parameters.vmName.type | should be "string"
        }

        It "vmName parameter is mandatory" {

            ($json.parameters.vmName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "vmName parameter minimum length is 1" {

            $json.parameters.vmName.minLength | should be 1
        }

        It "vmName parameter maximum length is 64" {

            $json.parameters.vmName.maxLength | should be 64
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

    Context "purchasePlanRequired Validation" {

        It "Has purchasePlanRequired parameter" {

            $json.parameters.purchasePlanRequired | should not be $null
        }

        It "purchasePlanRequired parameter is of type bool" {

            $json.parameters.purchasePlanRequired.type | should be "bool"
        }

        It "purchasePlanRequired parameter default value is false" {

            $json.parameters.purchasePlanRequired.defaultValue | should be $false
        }
    }

    Context "vmSize Validation" {

        It "Has vmSize parameter" {

            $json.parameters.vmSize | should not be $null
        }

        It "vmSize parameter is of type string" {

            $json.parameters.vmSize.type | should be "string"
        }

        It "vmSize parameter is mandatory" {

            ($json.parameters.vmSize.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "imagePublisher Validation" {

        It "Has imagePublisher parameter" {

            $json.parameters.imagePublisher | should not be $null
        }

        It "imagePublisher parameter is of type string" {

            $json.parameters.imagePublisher.type | should be "string"
        }

        It "imagePublisher parameter is mandatory" {

            ($json.parameters.imagePublisher.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "imageOffer Validation" {

        It "Has imageOffer parameter" {

            $json.parameters.imageOffer | should not be $null
        }

        It "imageOffer parameter is of type string" {

            $json.parameters.imageOffer.type | should be "string"
        }

        It "imageOffer parameter is mandatory" {

            ($json.parameters.imageOffer.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "imageSku Validation" {

        It "Has imageSku parameter" {

            $json.parameters.imageSku | should not be $null
        }

        It "imageSku parameter is of type string" {

            $json.parameters.imageSku.type | should be "string"
        }

        It "imageSku parameter is mandatory" {

            ($json.parameters.imageSku.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "osDiskName Validation" {

        It "Has osDiskName parameter" {

            $json.parameters.osDiskName | should not be $null
        }

        It "osDiskName parameter is of type string" {

            $json.parameters.osDiskName.type | should be "string"
        }

        It "osDiskName parameter is mandatory" {

            ($json.parameters.osDiskName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "osDiskCaching Validation" {

        It "Has osDiskCaching parameter" {

            $json.parameters.osDiskCaching | should not be $null
        }

        It "osDiskCaching parameter is of type string" {

            $json.parameters.osDiskCaching.type | should be "string"
        }

        It "osDiskCaching parameter default value is an empty string" {

            $json.parameters.osDiskCaching.defaultValue | should be ([String]::Empty)
        }

        It "osDiskCaching parameter allowed values are '', None, ReadOnly, ReadWrite" {

            (Compare-Object -ReferenceObject $json.parameters.osDiskCaching.allowedValues -DifferenceObject @("", "None", "ReadOnly", "ReadWrite")).Length | should be 0
        }
    }

    Context "osDiskCreateOption Validation" {

        It "Has osDiskCreateOption parameter" {

            $json.parameters.osDiskCreateOption | should not be $null
        }

        It "osDiskCreateOption parameter is of type string" {

            $json.parameters.osDiskCreateOption.type | should be "string"
        }

        It "osDiskCreateOption parameter default value is FromImage" {

            $json.parameters.osDiskCreateOption.defaultValue | should be "FromImage"
        }

        It "osDiskCreateOption parameter allowed values are FromImage, Empty, Attach" {

            (Compare-Object -ReferenceObject $json.parameters.osDiskCreateOption.allowedValues -DifferenceObject @("FromImage", "Empty", "Attach")).Length | should be 0
        }
    }

    Context "writeAcceleratorEnabled Validation" {

        It "Has writeAcceleratorEnabled parameter" {

            $json.parameters.writeAcceleratorEnabled | should not be $null
        }

        It "writeAcceleratorEnabled parameter is of type bool" {

            $json.parameters.writeAcceleratorEnabled.type | should be "bool"
        }

        It "writeAcceleratorEnabled parameter default value is false" {

            $json.parameters.writeAcceleratorEnabled.defaultValue | should be $false
        }
    }

    Context "osDiskSizeInGB Validation" {

        It "Has osDiskSizeInGB parameter" {

            $json.parameters.osDiskSizeInGB | should not be $null
        }

        It "osDiskSizeInGB parameter is of type int" {

            $json.parameters.osDiskSizeInGB.type | should be "int"
        }

        It "osDiskSizeInGB parameter default value is 32" {

            $json.parameters.osDiskSizeInGB.defaultValue | should be 32
        }

        It "osDiskSizeInGB parameter minimum value is 127" {

            $json.parameters.osDiskSizeInGB.minValue | should be 32
        }

        It "osDiskSizeInGB parameter maximum value is 2048" {

            $json.parameters.osDiskSizeInGB.maxValue | should be 2048
        }
    }

    Context "osDiskStorageAccountType Validation" {

        It "Has osDiskStorageAccountType parameter" {

            $json.parameters.osDiskStorageAccountType | should not be $null
        }

        It "osDiskStorageAccountType parameter is of type string" {

            $json.parameters.osDiskStorageAccountType.type | should be "string"
        }

        It "osDiskStorageAccountType parameter default value is Premium_LRS" {

            $json.parameters.osDiskStorageAccountType.defaultValue | should be "Premium_LRS"
        }

        It "osDiskStorageAccountType parameter allowed values are Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS" {

            (Compare-Object -ReferenceObject $json.parameters.osDiskStorageAccountType.allowedValues -DifferenceObject @("Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "UltraSSD_LRS")).Length | should be 0
        }
    }

    Context "dataDisks Validation" {

        It "Has dataDisks parameter" {

            $json.parameters.dataDisks | should not be $null
        }

        It "dataDisks parameter is of type array" {

            $json.parameters.dataDisks.type | should be "array"
        }

        It "dataDisks parameter default value is an empty array" {

            $json.parameters.dataDisks.defaultValue | should be @()
        }
    }

    Context "adminUsername Validation" {

        It "Has adminUsername parameter" {

            $json.parameters.adminUsername | should not be $null
        }

        It "adminUsername parameter is of type string" {

            $json.parameters.adminUsername.type | should be "string"
        }

        It "adminUsername parameter is mandatory" {

            ($json.parameters.adminUsername.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "adminPassword Validation" {

        It "Has adminPassword parameter" {

            $json.parameters.adminPassword | should not be $null
        }

        It "adminPassword parameter is of type securestring" {

            $json.parameters.adminPassword.type | should be "securestring"
        }

        It "adminPassword parameter is mandatory" {

            ($json.parameters.adminPassword.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "sshPublicKey Validation" {

        It "Has sshPublicKey parameter" {

            $json.parameters.sshPublicKey | should not be $null
        }

        It "sshPublicKey parameter is of type securestring" {

            $json.parameters.sshPublicKey.type | should be "securestring"
        }

        It "sshPublicKey parameter is mandatory" {

            ($json.parameters.sshPublicKey.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "networkInterfaces Validation" {

        It "Has networkInterfaces parameter" {

            $json.parameters.networkInterfaces | should not be $null
        }

        It "networkInterfaces parameter is of type array" {

            $json.parameters.networkInterfaces.type | should be "array"
        }

        It "networkInterfaces parameter is mandatory" {

            ($json.parameters.networkInterfaces.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "diagnosticsStorageAccountName Validation" {

        It "Has diagnosticsStorageAccountName parameter" {

            $json.parameters.diagnosticsStorageAccountName | should not be $null
        }

        It "diagnosticsStorageAccountName parameter is of type string" {

            $json.parameters.diagnosticsStorageAccountName.type | should be "string"
        }

        It "diagnosticsStorageAccountName parameter is mandatory" {

            ($json.parameters.diagnosticsStorageAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "availabilitySetId Validation" {

        It "Has availabilitySetId parameter" {

            $json.parameters.availabilitySetId | should not be $null
        }

        It "availabilitySetId parameter is of type string" {

            $json.parameters.availabilitySetId.type | should be "string"
        }

        It "availabilitySetId parameter default value is an empty string" {

            $json.parameters.availabilitySetId.defaultValue | should be ([String]::Empty)
        }
    }

    Context "zones Validation" {

        It "Has zones parameter" {

            $json.parameters.zones | should not be $null
        }

        It "zones parameter is of type array" {

            $json.parameters.zones.type | should be "array"
        }

        It "zones parameter default value is an empty array" {

            $json.parameters.zones.defaultValue | should be @()
        }
    }

    Context "templateContainerUrl Validation" {

        It "Has templateContainerUrl parameter" {

            $json.parameters.templateContainerUrl | should not be $null
        }

        It "templateContainerUrl parameter is of type string" {

            $json.parameters.templateContainerUrl.type | should be "string"
        }

        It "templateContainerUrl parameter is mandatory" {

            ($json.parameters.templateContainerUrl.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "templateSas Validation" {

        It "Has templateSas parameter" {

            $json.parameters.templateSas | should not be $null
        }

        It "templateSas parameter is of type securestring" {

            $json.parameters.templateSas.type | should be "securestring"
        }

        It "templateSas parameter is mandatory" {

            ($json.parameters.templateSas.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "dependencyAgentVersion Validation" {

        It "Has dependencyAgentVersion parameter" {

            $json.parameters.dependencyAgentVersion | should not be $null
        }

        It "dependencyAgentVersion parameter is of type string" {

            $json.parameters.dependencyAgentVersion.type | should be "string"
        }

        It "dependencyAgentVersion parameter default value is an empty string" {

            $json.parameters.dependencyAgentVersion.defaultValue | should be "9.10"
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

Describe "Linux Virtual Machine Resource Validation" {

    $vmResource = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Compute/virtualMachines" }
    $dependencyAgentResource = $json.resources | Where-Object { $PSItem.name -like "*DependencyAgentLinux*" }
    
    Context "type Validation" {

        It "type value is Microsoft.Compute/virtualMachines" {

            $vmResource.type | should be "Microsoft.Compute/virtualMachines"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $vmResource.apiVersion | should be "2020-06-01"
        }
    }

    Context "imageReference version Validation" {

        It "Uses latest image" {

            $vmResource.properties.storageProfile.imageReference.version | should be "latest"
        }
    }

    Context "osDisk Validation" {

        It "Uses Linux OS" {

            $vmResource.properties.storageProfile.osDisk.osType | should be "Linux"
        }
    }

    Context "additionalCapabilities Validation" {

        It "Uses ultra SSD if disk supports it" {

            $vmResource.properties.additionalCapabilities.ultraSSDEnabled | should be "[if(equals(parameters('osDiskStorageAccountType'), 'UltraSSD_LRS'), json('true'), json('false'))]"
        }
    }

    Context "linuxConfiguration Validation" {

        It "Provisions VM agent" {

            $vmResource.properties.osProfile.linuxConfiguration.provisionVMAgent | should be $true
        }
    }

    Context "bootDiagnostics Validation" {

        It "Boot diagnostics is enabled" {

            $vmResource.properties.diagnosticsProfile.bootDiagnostics.enabled | should be $true
        }
    }

    Context "DependencyAgentLinux Validation" {

        It "type is Microsoft.Resources/deployments" {

            $dependencyAgentResource.type | should be "Microsoft.Resources/deployments"
        }

        It "apiVersion is 2018-05-01" {

            $dependencyAgentResource.apiVersion | should be "2018-05-01"
        }

        It "mode is Incremental" {

            $dependencyAgentResource.properties.mode | should be "Incremental"
        }

        It "contentVersion is 1.0.4.0" {

            $dependencyAgentResource.properties.templateLink.contentVersion | should be "1.0.4.0"
        }

        It "vmExtensionName is DependencyAgentLinux" {

            $dependencyAgentResource.properties.parameters.vmExtensionName.value | should be "DependencyAgentLinux"
        }

        It "vmName is [parameters('vmName')]" {

            $dependencyAgentResource.properties.parameters.vmName.value | should be "[parameters('vmName')]"
        }

        It "publisher is Microsoft.Azure.Monitoring.DependencyAgent" {

            $dependencyAgentResource.properties.parameters.publisher.value | should be "Microsoft.Azure.Monitoring.DependencyAgent"
        }
        
        It "type is DependencyAgentLinux" {

            $dependencyAgentResource.properties.parameters.type.value | should be "DependencyAgentLinux"
        }

        It "depends on VM creation" {

            $dependencyAgentResource.dependsOn | should be @("[concat('Microsoft.Compute/virtualMachines/', parameters('vmName'))]")
        }
    }
}