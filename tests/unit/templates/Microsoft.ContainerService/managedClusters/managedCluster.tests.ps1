$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Managed Cluster Parameter Validation" {

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

    Context "kubernetesVersion Validation" {

        It "Has kubernetesVersion parameter" {

            $json.parameters.kubernetesVersion | should not be $null
        }

        It "kubernetesVersion parameter is of type string" {

            $json.parameters.kubernetesVersion.type | should be "string"
        }

        It "kubernetesVersion parameter is mandatory" {

            ($json.parameters.kubernetesVersion.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "dnsPrefix Validation" {

        It "Has dnsPrefix parameter" {

            $json.parameters.dnsPrefix | should not be $null
        }

        It "dnsPrefix parameter is of type string" {

            $json.parameters.dnsPrefix.type | should be "string"
        }

        It "dnsPrefix parameter is mandatory" {

            ($json.parameters.dnsPrefix.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "agentPoolProfiles Validation" {

        It "Has agentPoolProfiles parameter" {

            $json.parameters.agentPoolProfiles | should not be $null
        }

        It "agentPoolProfiles parameter is of type array" {

            $json.parameters.agentPoolProfiles.type | should be "array"
        }

        It "agentPoolProfiles parameter is mandatory" {

            ($json.parameters.agentPoolProfiles.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "adminUserName Validation" {

        It "Has adminUserName parameter" {

            $json.parameters.adminUserName | should not be $null
        }

        It "adminUserName parameter is of type string" {

            $json.parameters.adminUserName.type | should be "string"
        }

        It "adminUserName parameter default value is kubemonkey" {

            $json.parameters.adminUserName.defaultValue | should be "kubemonkey"
        }
    }

    Context "keyData Validation" {

        It "Has keyData parameter" {

            $json.parameters.keyData | should not be $null
        }

        It "keyData parameter is of type securestring" {

            $json.parameters.keyData.type | should be "securestring"
        }

        It "keyData parameter is mandatory" {

            ($json.parameters.keyData.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "licenseType Validation" {

        It "Has licenseType parameter" {

            $json.parameters.licenseType | should not be $null
        }

        It "licenseType parameter is of type string" {

            $json.parameters.licenseType.type | should be "string"
        }

        It "licenseType parameter default value is None" {

            $json.parameters.licenseType.defaultValue | should be "None"
        }

        It "licenseType parameter allowed values are None, Windows_Server" {

            (Compare-Object -ReferenceObject $json.parameters.licenseType.allowedValues -DifferenceObject @("None", "Windows_Server")).Length | should be 0
        }
    }

    Context "servicePrincipalProfile Validation" {

        It "Has servicePrincipalProfile parameter" {

            $json.parameters.servicePrincipalProfile | should not be $null
        }

        It "servicePrincipalProfile parameter is of type secureObject" {

            $json.parameters.servicePrincipalProfile.type | should be "secureObject"
        }

        It "servicePrincipalProfile parameter default value is an empty object" {

            $json.parameters.servicePrincipalProfile.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "addOnProfiles Validation" {

        It "Has addOnProfiles parameter" {

            $json.parameters.addOnProfiles | should not be $null
        }

        It "addOnProfiles parameter is of type object" {

            $json.parameters.addOnProfiles.type | should be "object"
        }

        It "addOnProfiles parameter default value is an empty object" {

            $json.parameters.addOnProfiles.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "podIdentityEnabled Validation" {

        It "Has podIdentityEnabled parameter" {

            $json.parameters.podIdentityEnabled | should not be $null
        }

        It "podIdentityEnabled parameter is of type bool" {

            $json.parameters.podIdentityEnabled.type | should be "bool"
        }

        It "podIdentityEnabled parameter default value is false" {

            $json.parameters.podIdentityEnabled.defaultValue | should be $false
        }
    }

    Context "userAssignedIdentities Validation" {

        It "Has userAssignedIdentities parameter" {

            $json.parameters.userAssignedIdentities | should not be $null
        }

        It "userAssignedIdentities parameter is of type array" {

            $json.parameters.userAssignedIdentities.type | should be "array"
        }

        It "userAssignedIdentities parameter default value is an empty array" {

            $json.parameters.userAssignedIdentities.defaultValue | should be @()
        }
    }

    Context "userAssignedIdentityExceptions Validation" {

        It "Has userAssignedIdentityExceptions parameter" {

            $json.parameters.userAssignedIdentityExceptions | should not be $null
        }

        It "userAssignedIdentityExceptions parameter is of type array" {

            $json.parameters.userAssignedIdentityExceptions.type | should be "array"
        }

        It "userAssignedIdentityExceptions parameter default value is an empty array" {

            $json.parameters.userAssignedIdentityExceptions.defaultValue | should be @()
        }
    }

    Context "nodeResourceGroup Validation" {

        It "Has nodeResourceGroup parameter" {

            $json.parameters.nodeResourceGroup | should not be $null
        }

        It "nodeResourceGroup parameter is of type string" {

            $json.parameters.nodeResourceGroup.type | should be "string"
        }

        It "nodeResourceGroup parameter is mandatory" {

            ($json.parameters.nodeResourceGroup.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "enableRBAC Validation" {

        It "Has enableRBAC parameter" {

            $json.parameters.enableRBAC | should not be $null
        }

        It "enableRBAC parameter is of type bool" {

            $json.parameters.enableRBAC.type | should be "bool"
        }

        It "enableRBAC parameter default value is false" {

            $json.parameters.enableRBAC.defaultValue | should be $true
        }
    }

    Context "networkProfile Validation" {

        It "Has networkProfile parameter" {

            $json.parameters.networkProfile | should not be $null
        }

        It "networkProfile parameter is of type object" {

            $json.parameters.networkProfile.type | should be "object"
        }

        It "networkProfile parameter default value is an empty object" {

            $json.parameters.networkProfile.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "enableManagedAad Validation" {

        It "Has enableManagedAad parameter" {

            $json.parameters.enableManagedAad | should not be $null
        }

        It "enableManagedAad parameter is of type bool" {

            $json.parameters.enableManagedAad.type | should be "bool"
        }

        It "enableManagedAad parameter default value is false" {

            $json.parameters.enableManagedAad.defaultValue | should be $true
        }
    }

    Context "enableAzureRBAC Validation" {

        It "Has enableAzureRBAC parameter" {

            $json.parameters.enableAzureRBAC | should not be $null
        }

        It "enableAzureRBAC parameter is of type bool" {

            $json.parameters.enableAzureRBAC.type | should be "bool"
        }

        It "enableAzureRBAC parameter default value is false" {

            $json.parameters.enableAzureRBAC.defaultValue | should be $false
        }
    }

    Context "adminGroupObjectIDs Validation" {

        It "Has adminGroupObjectIDs parameter" {

            $json.parameters.adminGroupObjectIDs | should not be $null
        }

        It "adminGroupObjectIDs parameter is of type array" {

            $json.parameters.adminGroupObjectIDs.type | should be "array"
        }

        It "adminGroupObjectIDs parameter default value is an empty array" {

            $json.parameters.adminGroupObjectIDs.defaultValue | should be @()
        }
    }

    Context "autoScalerProfile Validation" {

        It "Has autoScalerProfile parameter" {

            $json.parameters.autoScalerProfile | should not be $null
        }

        It "autoScalerProfile parameter is of type object" {

            $json.parameters.autoScalerProfile.type | should be "object"
        }

        It "autoScalerProfile parameter default value is an empty object" {

            $json.parameters.autoScalerProfile.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "authorizedIPRanges Validation" {

        It "Has authorizedIPRanges parameter" {

            $json.parameters.authorizedIPRanges | should not be $null
        }

        It "authorizedIPRanges parameter is of type array" {

            $json.parameters.authorizedIPRanges.type | should be "array"
        }

        It "authorizedIPRanges parameter default value is an empty array" {

            $json.parameters.adminGroupObjectIDs.defaultValue | should be @()
        }
    }

    Context "enablePrivateCluster Validation" {

        It "Has enablePrivateCluster parameter" {

            $json.parameters.enablePrivateCluster | should not be $null
        }

        It "enablePrivateCluster parameter is of type bool" {

            $json.parameters.enablePrivateCluster.type | should be "bool"
        }

        It "enablePrivateCluster parameter default value is false" {

            $json.parameters.enableAzureRBAC.defaultValue | should be $false
        }
    }

    Context "privateDNSZone Validation" {

        It "Has privateDNSZone parameter" {

            $json.parameters.privateDNSZone | should not be $null
        }

        It "privateDNSZone parameter is of type string" {

            $json.parameters.privateDNSZone.type | should be "string"
        }

        It "privateDNSZone parameter default value is an empty string" {

            $json.parameters.privateDNSZone.defaultValue | should be ([String]::Empty)
        }
    }

    Context "tier Validation" {

        It "Has tier parameter" {

            $json.parameters.tier | should not be $null
        }

        It "tier parameter is of type string" {

            $json.parameters.tier.type | should be "string"
        }

        It "tier parameter default value is Free" {

            $json.parameters.tier.defaultValue | should be "Free"
        }

        It "tier parameter allowed values are Free, Paid" {

            (Compare-Object -ReferenceObject $json.parameters.tier.allowedValues -DifferenceObject @("Free", "Paid")).Length | should be 0
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

    Context "logAnalyticsName Validation" {

        It "Has logAnalyticsName parameter" {

            $json.parameters.logAnalyticsName | should not be $null
        }

        It "logAnalyticsName parameter is of type string" {

            $json.parameters.logAnalyticsName.type | should be "string"
        }

        It "logAnalyticsName parameter is mandatory" {

            ($json.parameters.logAnalyticsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "Diagnostic Settings Validation" {

        It "diagnosticsEnabled variable is true" {

            $json.variables.diagnosticsEnabled | should be $true
        }

        It "diagnosticsRetentionInDays is 365" {

            $json.variables.diagnosticsRetentionInDays | should be 365
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

Describe "Managed Cluster Resource Validation" {

    $cluster = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ContainerService/managedClusters" }
    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.ContainerService/managedClusters" {

            $cluster.type | should be "Microsoft.ContainerService/managedClusters"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-11-01" {

            $cluster.apiVersion | should be "2020-11-01"
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is /providers/diagnosticSettings" {

            $diagnostics.type | should be "/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $diagnostics.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to AllMetrics" {

            $diagnostics.properties.metrics.category | should be "AllMetrics"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("kube-apiserver", "kube-audit", "kube-audit-admin", "kube-controller-manager", "kube-scheduler", "cluster-autoscaler", "guard")).Length | should be 0
        }
    }
}

Describe "Managed Cluster Validation" {

    Context "Managed Cluster Reference Validation" {

        It "type value is object" {

            $json.outputs.cluster.type | should be "object"
        }

        It "Uses full reference for Schedule" {

            $json.outputs.cluster.value | should be "[reference(resourceId('Microsoft.ContainerService/managedClusters', parameters('clusterName')), '2020-11-01', 'Full')]"
        }
    }
}