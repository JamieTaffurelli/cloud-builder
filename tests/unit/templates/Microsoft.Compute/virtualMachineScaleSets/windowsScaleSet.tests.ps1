$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Windows Virtual Machine Scale Set Parameter Validation" {

    Context "scaleSetName Validation" {

        It "Has scaleSetName parameter" {

            $json.parameters.scaleSetName | should not be $null
        }

        It "scaleSetName parameter is of type string" {

            $json.parameters.scaleSetName.type | should be "string"
        }

        It "scaleSetName parameter is mandatory" {

            ($json.parameters.scaleSetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "scaleSetName parameter minimum length is 1" {

            $json.parameters.scaleSetName.minLength | should be 1
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

    Context "skuName Validation" {

        It "Has skuName parameter" {

            $json.parameters.skuName | should not be $null
        }

        It "skuName parameter is of type string" {

            $json.parameters.skuName.type | should be "string"
        }

        It "skuName parameter is mandatory" {

            ($json.parameters.skuName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "skuTier Validation" {

        It "Has skuTier parameter" {

            $json.parameters.skuTier | should not be $null
        }

        It "skuTier parameter is of type string" {

            $json.parameters.skuTier.type | should be "string"
        }

        It "skuTier parameter default value is Standard" {

            $json.parameters.skuTier.defaultValue | should be "Standard"
        }

        It "skuTier parameter allowed values are Standard, Basic" {

            (Compare-Object -ReferenceObject $json.parameters.skuTier.allowedValues -DifferenceObject @("Standard", "Basic")).Length | should be 0
        }
    }

    Context "skuCapacity Validation" {

        It "Has skuCapacity parameter" {

            $json.parameters.skuCapacity | should not be $null
        }

        It "skuCapacity parameter is of type int" {

            $json.parameters.skuCapacity.type | should be "int"
        }

        It "skuCapacity parameter default value is 0" {

            $json.parameters.skuCapacity.defaultValue | should be 0
        }

        It "skuCapacity parameter minValue is 0" {

            $json.parameters.skuCapacity.minValue | should be 0
        }
        
        It "skuCapacity parameter maxValue is 1000" {

            $json.parameters.skuCapacity.maxValue | should be 1000
        }
    }

    Context "imagePurchasePlanRequired Validation" {

        It "Has imagePurchasePlanRequired parameter" {

            $json.parameters.imagePurchasePlanRequired | should not be $null
        }

        It "imagePurchasePlanRequired parameter is of type bool" {

            $json.parameters.imagePurchasePlanRequired.type | should be "bool"
        }

        It "imagePurchasePlanRequired parameter default value is false" {

            $json.parameters.imagePurchasePlanRequired.defaultValue | should be $false
        }
    }

    Context "imagePublisher Validation" {

        It "Has imagePublisher parameter" {

            $json.parameters.imagePublisher | should not be $null
        }

        It "imagePublisher parameter is of type string" {

            $json.parameters.imagePublisher.type | should be "string"
        }

        It "imagePublisher parameter default value is MicrosoftWindowsServer" {

            $json.parameters.imagePublisher.defaultValue | should be "MicrosoftWindowsServer"
        }
    }

    Context "imageOffer Validation" {

        It "Has imageOffer parameter" {

            $json.parameters.imageOffer | should not be $null
        }

        It "imageOffer parameter is of type string" {

            $json.parameters.imageOffer.type | should be "string"
        }

        It "imageOffer parameter default value is WindowsServer" {

            $json.parameters.imageOffer.defaultValue | should be "WindowsServer"
        }
    }

    Context "imageSku Validation" {

        It "Has imageSku parameter" {

            $json.parameters.imageSku | should not be $null
        }

        It "imageSku parameter is of type string" {

            $json.parameters.imageSku.type | should be "string"
        }

        It "imageSku parameter default value is 2016-Datacenter" {

            $json.parameters.imageSku.defaultValue | should be "2016-Datacenter"
        }
    }

    Context "upgradeMode Validation" {

        It "Has upgradeMode parameter" {

            $json.parameters.upgradeMode | should not be $null
        }

        It "upgradeMode parameter is of type string" {

            $json.parameters.upgradeMode.type | should be "string"
        }

        It "upgradeMode parameter default value is Manual" {

            $json.parameters.upgradeMode.defaultValue | should be "Manual"
        }
        
        It "upgradeMode parameter allowed values are Manual, Automatic" {

            (Compare-Object -ReferenceObject $json.parameters.upgradeMode.allowedValues `
                -DifferenceObject @("Manual", "Automatic")).Length | should be 0
        }
    }

    Context "upgradeRollingMaxBatchPercent Validation" {

        It "Has upgradeRollingMaxBatchPercent parameter" {

            $json.parameters.upgradeRollingMaxBatchPercent | should not be $null
        }

        It "upgradeRollingMaxBatchPercent parameter is of type int" {

            $json.parameters.upgradeRollingMaxBatchPercent.type | should be "int"
        }

        It "upgradeRollingMaxBatchPercent parameter default value is 20" {

            $json.parameters.upgradeRollingMaxBatchPercent.defaultValue | should be 20
        }

        It "upgradeRollingMaxBatchPercent parameter minValue is 0" {

            $json.parameters.upgradeRollingMaxBatchPercent.minValue | should be 0
        }
        
        It "upgradeRollingMaxBatchPercent parameter maxValue is 0" {

            $json.parameters.upgradeRollingMaxBatchPercent.maxValue | should be 100
        }
    }

    Context "upgradeRollingMaxUnhealthyPercent Validation" {

        It "Has upgradeRollingMaxUnhealthyPercent parameter" {

            $json.parameters.upgradeRollingMaxUnhealthyPercent | should not be $null
        }

        It "upgradeRollingMaxUnhealthyPercent parameter is of type int" {

            $json.parameters.upgradeRollingMaxUnhealthyPercent.type | should be "int"
        }

        It "upgradeRollingMaxUnhealthyPercent parameter default value is 20" {

            $json.parameters.upgradeRollingMaxUnhealthyPercent.defaultValue | should be 20
        }

        It "upgradeRollingMaxUnhealthyPercent parameter minValue is 0" {

            $json.parameters.upgradeRollingMaxUnhealthyPercent.minValue | should be 0
        }
        
        It "upgradeRollingMaxUnhealthyPercent parameter maxValue is 0" {

            $json.parameters.upgradeRollingMaxUnhealthyPercent.maxValue | should be 100
        }
    }

    Context "upgradeRollingMaxUnhealthyUpgradedPercent Validation" {

        It "Has upgradeRollingMaxUnhealthyUpgradedPercent parameter" {

            $json.parameters.upgradeRollingMaxUnhealthyUpgradedPercent | should not be $null
        }

        It "upgradeRollingMaxUnhealthyUpgradedPercent parameter is of type int" {

            $json.parameters.upgradeRollingMaxUnhealthyUpgradedPercent.type | should be "int"
        }

        It "upgradeRollingMaxUnhealthyUpgradedPercent parameter default value is 20" {

            $json.parameters.upgradeRollingMaxUnhealthyUpgradedPercent.defaultValue | should be 20
        }

        It "upgradeRollingMaxUnhealthyUpgradedPercent parameter minValue is 0" {

            $json.parameters.upgradeRollingMaxUnhealthyUpgradedPercent.minValue | should be 0
        }
        
        It "upgradeRollingMaxUnhealthyUpgradedPercent parameter maxValue is 0" {

            $json.parameters.upgradeRollingMaxUnhealthyUpgradedPercent.maxValue | should be 100
        }
    }

    Context "upgradeRollingPauseTime Validation" {

        It "Has upgradeRollingPauseTime parameter" {

            $json.parameters.upgradeRollingPauseTime | should not be $null
        }

        It "upgradeRollingPauseTime parameter is of type string" {

            $json.parameters.upgradeRollingPauseTime.type | should be "string"
        }

        It "upgradeRollingPauseTime parameter default value is PT0S" {

            $json.parameters.upgradeRollingPauseTime.defaultValue | should be "PT0S"
        }
    }

    Context "upgradeAutoOSUpgradeEnabled Validation" {

        It "Has upgradeAutoOSUpgradeEnabled parameter" {

            $json.parameters.upgradeAutoOSUpgradeEnabled | should not be $null
        }

        It "upgradeAutoOSUpgradeEnabled parameter is of type bool" {

            $json.parameters.upgradeAutoOSUpgradeEnabled.type | should be "bool"
        }

        It "upgradeAutoOSUpgradeEnabled parameter default value is false" {

            $json.parameters.upgradeAutoOSUpgradeEnabled.defaultValue | should be $false
        }
    }

    Context "upgradeAutoOSUpgradeDisableRollback Validation" {

        It "Has upgradeAutoOSUpgradeDisableRollback parameter" {

            $json.parameters.upgradeAutoOSUpgradeDisableRollback | should not be $null
        }

        It "upgradeAutoOSUpgradeDisableRollback parameter is of type bool" {

            $json.parameters.upgradeAutoOSUpgradeDisableRollback.type | should be "bool"
        }

        It "upgradeAutoOSUpgradeDisableRollback parameter default value is false" {

            $json.parameters.upgradeAutoOSUpgradeDisableRollback.defaultValue | should be $false
        }
    }

    Context "autoRepairEnabled Validation" {

        It "Has autoRepairEnabled parameter" {

            $json.parameters.autoRepairEnabled | should not be $null
        }

        It "autoRepairEnabled parameter is of type bool" {

            $json.parameters.autoRepairEnabled.type | should be "bool"
        }

        It "autoRepairEnabled parameter default value is false" {

            $json.parameters.autoRepairEnabled.defaultValue | should be $false
        }
    }

    Context "autoRepairGracePeriod Validation" {

        It "Has autoRepairGracePeriod parameter" {

            $json.parameters.autoRepairGracePeriod | should not be $null
        }

        It "autoRepairGracePeriod parameter is of type string" {

            $json.parameters.autoRepairGracePeriod.type | should be "string"
        }

        It "autoRepairGracePeriod parameter default value is PT30M" {

            $json.parameters.autoRepairGracePeriod.defaultValue | should be "PT30M"
        }
    }

    Context "vmNamePrefix Validation" {

        It "Has vmNamePrefix parameter" {

            $json.parameters.vmNamePrefix | should not be $null
        }

        It "vmNamePrefix parameter is of type string" {

            $json.parameters.vmNamePrefix.type | should be "string"
        }

        It "vmNamePrefix parameter is mandatory" {

            ($json.parameters.vmNamePrefix.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vmAdminUsername Validation" {

        It "Has vmAdminUsername parameter" {

            $json.parameters.vmAdminUsername | should not be $null
        }

        It "vmAdminUsername parameter is of type string" {

            $json.parameters.vmAdminUsername.type | should be "string"
        }

        It "vmAdminUsername parameter is mandatory" {

            ($json.parameters.vmAdminUsername.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vmAdminPassword Validation" {

        It "Has vmAdminPassword parameter" {

            $json.parameters.vmAdminPassword | should not be $null
        }

        It "vmAdminPassword parameter is of type securestring" {

            $json.parameters.vmAdminPassword.type | should be "securestring"
        }

        It "vmAdminPassword parameter is mandatory" {

            ($json.parameters.vmAdminPassword.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vmEnableAutomaticUpdates Validation" {

        It "Has vmEnableAutomaticUpdates parameter" {

            $json.parameters.vmEnableAutomaticUpdates | should not be $null
        }

        It "vmEnableAutomaticUpdates parameter is of type bool" {

            $json.parameters.vmEnableAutomaticUpdates.type | should be "bool"
        }

        It "vmEnableAutomaticUpdates parameter default value is true" {

            $json.parameters.vmEnableAutomaticUpdates.defaultValue | should be $false
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

        It "osDiskSizeInGB parameter default value is 127" {

            $json.parameters.osDiskSizeInGB.defaultValue | should be 127
        }

        It "osDiskSizeInGB parameter minimum value is 127" {

            $json.parameters.osDiskSizeInGB.minValue | should be 127
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

    Context "nicIpConfigurationName Validation" {

        It "Has nicIpConfigurationName parameter" {

            $json.parameters.nicIpConfigurationName | should not be $null
        }

        It "nicIpConfigurationName parameter is of type string" {

            $json.parameters.nicIpConfigurationName.type | should be "string"
        }

        It "nicIpConfigurationName parameter default value is ipconfig1" {

            $json.parameters.nicIpConfigurationName.defaultValue | should be "ipconfig1"
        }
    }

    Context "nicEnableAcceleratedNetworking Validation" {

        It "Has nicEnableAcceleratedNetworking parameter" {

            $json.parameters.nicEnableAcceleratedNetworking | should not be $null
        }

        It "nicEnableAcceleratedNetworking parameter is of type bool" {

            $json.parameters.nicEnableAcceleratedNetworking.type | should be "bool"
        }

        It "nicEnableAcceleratedNetworking parameter default value is an true" {

            $json.parameters.nicEnableAcceleratedNetworking.defaultValue | should be $true
        }
    }

    Context "nicEnableIPForwarding Validation" {

        It "Has nicEnableIPForwarding parameter" {

            $json.parameters.nicEnableIPForwarding | should not be $null
        }

        It "nicEnableIPForwarding parameter is of type bool" {

            $json.parameters.nicEnableIPForwarding.type | should be "bool"
        }

        It "nicEnableIPForwarding parameter default value is an false" {

            $json.parameters.nicEnableIPForwarding.defaultValue | should be $false
        }
    }

    Context "nicNetworkSubscriptionId Validation" {

        It "Has nicNetworkSubscriptionId parameter" {

            $json.parameters.nicNetworkSubscriptionId | should not be $null
        }

        It "nicNetworkSubscriptionId parameter is of type string" {

            $json.parameters.nicNetworkSubscriptionId.type | should be "string"
        }

        It "nicNetworkSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.nicNetworkSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "nicNetworkResourceGroupName Validation" {

        It "Has nicNetworkResourceGroupName parameter" {

            $json.parameters.nicNetworkResourceGroupName | should not be $null
        }

        It "nicNetworkResourceGroupName parameter is of type string" {

            $json.parameters.nicNetworkResourceGroupName.type | should be "string"
        }

        It "nicNetworkResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.nicNetworkResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "nicNetworkSecurityGroupName Validation" {

        It "Has nicNetworkSecurityGroupName parameter" {

            $json.parameters.nicNetworkSecurityGroupName | should not be $null
        }

        It "nicNetworkSecurityGroupName parameter is of type string" {

            $json.parameters.nicNetworkSecurityGroupName.type | should be "string"
        }

        It "nicNetworkSecurityGroupName parameter is mandatory" {

            ($json.parameters.nicNetworkSecurityGroupName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "dnsServers Validation" {

        It "Has dnsServers parameter" {

            $json.parameters.dnsServers | should not be $null
        }

        It "dnsServers parameter is of type array" {

            $json.parameters.dnsServers.type | should be "array"
        }

        It "dnsServers parameter default value is []" {

            $json.parameters.dnsServers.defaultValue | should be @()
        }
    }

    Context "nicVirtualNetworkName Validation" {

        It "Has nicVirtualNetworkName parameter" {

            $json.parameters.nicVirtualNetworkName | should not be $null
        }

        It "nicVirtualNetworkName parameter is of type string" {

            $json.parameters.nicVirtualNetworkName.type | should be "string"
        }

        It "nicVirtualNetworkName parameter is mandatory" {

            ($json.parameters.nicVirtualNetworkName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "nicSubnetName Validation" {

        It "Has nicSubnetName parameter" {

            $json.parameters.nicSubnetName | should not be $null
        }

        It "nicSubnetName parameter is of type string" {

            $json.parameters.nicSubnetName.type | should be "string"
        }

        It "nicSubnetName parameter is mandatory" {

            ($json.parameters.nicSubnetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "nicName Validation" {

        It "Has nicName parameter" {

            $json.parameters.nicName | should not be $null
        }

        It "nicName parameter is of type string" {

            $json.parameters.nicName.type | should be "string"
        }

        It "nicName parameter is mandatory" {

            ($json.parameters.nicName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "nicPrivateIpAddressVersion Validation" {

        It "Has nicPrivateIpAddressVersion parameter" {

            $json.parameters.nicPrivateIpAddressVersion | should not be $null
        }

        It "nicPrivateIpAddressVersion parameter is of type string" {

            $json.parameters.nicPrivateIpAddressVersion.type | should be "string"
        }

        It "nicPrivateIpAddressVersion parameter default value is IPv4" {

            $json.parameters.nicPrivateIpAddressVersion.defaultValue | should be "IPv4"
        }
    }

    Context "priority Validation" {

        It "Has priority parameter" {

            $json.parameters.priority | should not be $null
        }

        It "priority parameter is of type string" {

            $json.parameters.priority.type | should be "string"
        }

        It "priority parameter default value is Regular" {

            $json.parameters.priority.defaultValue | should be "Regular"
        }

        It "priority parameter allowed values are Regular, Low, Spot" {

            (Compare-Object -ReferenceObject $json.parameters.priority.allowedValues `
                -DifferenceObject @("Regular", "Low", "Spot")).Length | should be 0
        }
    }

    Context "evictionPolicy Validation" {

        It "Has evictionPolicy parameter" {

            $json.parameters.evictionPolicy | should not be $null
        }

        It "evictionPolicy parameter is of type string" {

            $json.parameters.evictionPolicy.type | should be "string"
        }

        It "evictionPolicy parameter default value is Deallocate" {

            $json.parameters.evictionPolicy.defaultValue | should be "Deallocate"
        }

        It "evictionPolicy parameter allowed values are Deallocate, Delete" {

            (Compare-Object -ReferenceObject $json.parameters.evictionPolicy.allowedValues `
                -DifferenceObject @("Deallocate", "Delete")).Length | should be 0
        }
    }

    Context "billingMaxPrice Validation" {

        It "Has billingMaxPrice parameter" {

            $json.parameters.billingMaxPrice | should not be $null
        }

        It "billingMaxPrice parameter is of type number" {

            $json.parameters.billingMaxPrice.type | should be "number"
        }

        It "billingMaxPrice parameter default value is -1" {

            $json.parameters.billingMaxPrice.defaultValue | should be -1
        }

        It "billingMaxPrice parameter minimum value is -1" {

            $json.parameters.billingMaxPrice.minValue | should be -1
        }
    }

    Context "overprovision Validation" {

        It "Has overprovision parameter" {

            $json.parameters.overprovision | should not be $null
        }

        It "overprovision parameter is of type bool" {

            $json.parameters.overprovision.type | should be "bool"
        }

        It "overprovision parameter default value is true" {

            $json.parameters.overprovision.defaultValue | should be $true
        }
    }

    Context "doNotRunExtensionsOnOverprovisionedVMs Validation" {

        It "Has doNotRunExtensionsOnOverprovisionedVMs parameter" {

            $json.parameters.doNotRunExtensionsOnOverprovisionedVMs | should not be $null
        }

        It "doNotRunExtensionsOnOverprovisionedVMs parameter is of type bool" {

            $json.parameters.doNotRunExtensionsOnOverprovisionedVMs.type | should be "bool"
        }

        It "doNotRunExtensionsOnOverprovisionedVMs parameter default value is true" {

            $json.parameters.doNotRunExtensionsOnOverprovisionedVMs.defaultValue | should be $true
        }
    }

    Context "singlePlacementGroup Validation" {

        It "Has singlePlacementGroup parameter" {

            $json.parameters.singlePlacementGroup | should not be $null
        }

        It "singlePlacementGroup parameter is of type bool" {

            $json.parameters.singlePlacementGroup.type | should be "bool"
        }

        It "singlePlacementGroup parameter default value is false" {

            $json.parameters.singlePlacementGroup.defaultValue | should be $false
        }
    }

    Context "zoneBalance Validation" {

        It "Has zoneBalance parameter" {

            $json.parameters.zoneBalance | should not be $null
        }

        It "zoneBalance parameter is of type bool" {

            $json.parameters.zoneBalance.type | should be "bool"
        }

        It "zoneBalance parameter default value is false" {

            $json.parameters.zoneBalance.defaultValue | should be $false
        }
    }

    Context "platformFaultDomainCount Validation" {

        It "Has platformFaultDomainCount parameter" {

            $json.parameters.platformFaultDomainCount | should not be $null
        }

        It "platformFaultDomainCount parameter is of type int" {

            $json.parameters.platformFaultDomainCount.type | should be "int"
        }

        It "platformFaultDomainCount parameter default value is 0" {

            $json.parameters.platformFaultDomainCount.defaultValue | should be 0
        }
    }

    Context "scaleInPolicy Validation" {

        It "Has scaleInPolicy parameter" {

            $json.parameters.scaleInPolicy | should not be $null
        }

        It "scaleInPolicy parameter is of type array" {

            $json.parameters.scaleInPolicy.type | should be "array"
        }

        It "scaleInPolicy parameter default values are Default" {

            (Compare-Object -ReferenceObject $json.parameters.scaleInPolicy.defaultValue `
                -DifferenceObject @("Default")).Length | should be 0
        }
    }

    Context "zones Validation" {

        It "Has zones parameter" {

            $json.parameters.zones | should not be $null
        }

        It "zones parameter is of type array" {

            $json.parameters.zones.type | should be "array"
        }

        It "zones parameter default values are Primary" {

            (Compare-Object -ReferenceObject $json.parameters.zones.defaultValue `
                -DifferenceObject @("Primary")).Length | should be 0
        }
    }

    Context "bgVersion Validation" {

        It "Has bgVersion parameter" {

            $json.parameters.bgVersion | should not be $null
        }

        It "bgVersion parameter is of type string" {

            $json.parameters.bgVersion.type | should be "string"
        }

        It "bgVersion parameter default value is an empty string" {

            $json.parameters.bgVersion.defaultValue | should be "2.1"
        }
    }

    Context "dependencyAgentVersion Validation" {

        It "Has dependencyAgentVersion parameter" {

            $json.parameters.dependencyAgentVersion | should not be $null
        }

        It "dependencyAgentVersion parameter is of type string" {

            $json.parameters.dependencyAgentVersion.type | should be "string"
        }

        It "dependencyAgentVersion parameter default value is 9.9" {

            $json.parameters.dependencyAgentVersion.defaultValue | should be "9.9"
        }
    }

    Context "logAnalyticsSubscriptionId Validation" {

        It "Has logAnalyticsSubscriptionId parameter" {

            $json.parameters.logAnalyticsSubscriptionId | should not be $null
        }

        It "logAnalyticsSubscriptionId parameter is of type string" {

            $json.parameters.logAnalyticsSubscriptionId.type | should be "string"
        }

        It "logAnalyticsSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.logAnalyticsSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "logAnalyticsResourceGroupName Validation" {

        It "Has logAnalyticsResourceGroupName parameter" {

            $json.parameters.logAnalyticsResourceGroupName | should not be $null
        }

        It "logAnalyticsResourceGroupName parameter is of type string" {

            $json.parameters.logAnalyticsResourceGroupName.type | should be "string"
        }

        It "logAnalyticsResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.logAnalyticsResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "logAnalyticsWorkspaceName Validation" {

        It "Has logAnalyticsWorkspaceName parameter" {

            $json.parameters.logAnalyticsWorkspaceName | should not be $null
        }

        It "logAnalyticsWorkspaceName parameter is of type string" {

            $json.parameters.logAnalyticsWorkspaceName.type | should be "string"
        }

        It "logAnalyticsWorkspaceName parameter is mandatory" {

            ($json.parameters.logAnalyticsWorkspaceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "extensions Validation" {

        It "Has extensions parameter" {

            $json.parameters.extensions | should not be $null
        }

        It "extensions parameter is of type array" {

            $json.parameters.extensions.type | should be "array"
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

Describe "Windows Virtual Machine Scale Set Resource Validation" {

    $vmResource = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Compute/virtualMachineScaleSets" }
    
    Context "type Validation" {

        It "type value is Microsoft.Compute/virtualMachineScaleSets" {

            $vmResource.type | should be "Microsoft.Compute/virtualMachineScaleSets"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-03-01" {

            $vmResource.apiVersion | should be "2019-03-01"
        }
    }

    Context "imageReference version Validation" {

        It "Uses latest image" {

            $vmResource.properties.virtualMachineProfile.storageProfile.imageReference.version | should be "latest"
        }
    }

    Context "osDisk Validation" {

        It "Uses Windows OS" {

            $vmResource.properties.virtualMachineProfile.storageProfile.osDisk.osType | should be "Windows"
        }
    }

    Context "additionalCapabilities Validation" {

        It "Uses ultra SSD if disk supports it" {

            $vmResource.properties.additionalCapabilities.ultraSSDEnabled | should be "[if(equals(parameters('osDiskStorageAccountType'), 'UltraSSD_LRS'), json('true'), json('false'))]"
        }
    }

    Context "windowsConfiguration Validation" {

        It "Provisions VM agent" {

            $vmResource.properties.virtualMachineProfile.osProfile.windowsConfiguration.provisionVMAgent | should be $true
        }
    }

    Context "bootDiagnostics Validation" {

        It "Boot diagnostics is enabled" {

            $vmResource.properties.virtualMachineProfile.diagnosticsProfile.bootDiagnostics.enabled | should be $true
        }
    }
}