$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Public IP Parameter Validation" {

    Context "publicIPName Validation" {

        It "Has publicIPName parameter" {

            $json.parameters.publicIPName | should not be $null
        }

        It "publicIPName parameter is of type string" {

            $json.parameters.publicIPName.type | should be "string"
        }

        It "publicIPName parameter is mandatory" {

            ($json.parameters.publicIPName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "publicIPName parameter is minimum length is 1" {

            $json.parameters.publicIPName.minLength | should be 1
        }

        It "publicIPName parameter is maximum length is 80" {

            $json.parameters.publicIPName.maxLength | should be 80
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

        It "sku parameter allowed values are Basic, Standard" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Basic", "Standard")).Length | should be 0
        }
    }

    Context "publicIpAllocationMethod Validation" {

        It "Has publicIpAllocationMethod parameter" {

            $json.parameters.publicIpAllocationMethod | should not be $null
        }

        It "publicIpAllocationMethod parameter is of type string" {

            $json.parameters.publicIpAllocationMethod.type | should be "string"
        }

        It "publicIpAllocationMethod parameter default value is static" {

            $json.parameters.publicIpAllocationMethod.defaultValue | should be "static"
        }

        It "publicIpAllocationMethod parameter allowed values are static, dynamic" {

            (Compare-Object -ReferenceObject $json.parameters.publicIpAllocationMethod.allowedValues -DifferenceObject @("static", "dynamic")).Length | should be 0
        }
    }

    Context "publicIPAddressVersion Validation" {

        It "Has publicIPAddressVersion parameter" {

            $json.parameters.publicIPAddressVersion | should not be $null
        }

        It "publicIPAddressVersion parameter is of type string" {

            $json.parameters.publicIPAddressVersion.type | should be "string"
        }

        It "publicIPAddressVersion parameter default value is IPv4" {

            $json.parameters.publicIPAddressVersion.defaultValue | should be "IPv4"
        }

        It "publicIPAddressVersion parameter allowed values are IPv4, IPv6" {

            (Compare-Object -ReferenceObject $json.parameters.publicIPAddressVersion.allowedValues -DifferenceObject @("IPv4", "IPv6")).Length | should be 0
        }
    }

    Context "domainNameLabel Validation" {

        It "Has domainNameLabel parameter" {

            $json.parameters.domainNameLabel | should not be $null
        }

        It "domainNameLabel parameter is of type string" {

            $json.parameters.domainNameLabel.type | should be "string"
        }

        It "domainNameLabel parameter is mandatory" {

            ($json.parameters.domainNameLabel.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "dnsSettings Validation" {

        It "Has dnsSettings parameter" {

            $json.parameters.dnsSettings | should not be $null
        }

        It "dnsSettings parameter is of type object" {

            $json.parameters.dnsSettings.type | should be "object"
        }

        It "dnsSettings parameter default value is an empty object" {

            $json.parameters.dnsSettings.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "ipTags Validation" {

        It "Has ipTags parameter" {

            $json.parameters.ipTags | should not be $null
        }

        It "ipTags parameter is of type array" {

            $json.parameters.ipTags.type | should be "array"
        }

        It "ipTags parameter default value is an empty array" {

            $json.parameters.ipTags.defaultValue | should be @()
        }
    }

    Context "ipAddress Validation" {

        It "Has ipAddress parameter" {

            $json.parameters.ipAddress | should not be $null
        }

        It "ipAddress parameter is of type string" {

            $json.parameters.ipAddress.type | should be "string"
        }

        It "ipAddress parameter default value is an empty string" {

            $json.parameters.ipAddress.defaultValue | should be ([String]::Empty)
        }
    }

    Context "idleTimeoutInMinutes Validation" {

        It "Has idleTimeoutInMinutes parameter" {

            $json.parameters.idleTimeoutInMinutes | should not be $null
        }

        It "idleTimeoutInMinutes parameter is of type int" {

            $json.parameters.idleTimeoutInMinutes.type | should be "int"
        }

        It "idleTimeoutInMinutes parameter default value is 4" {

            $json.parameters.idleTimeoutInMinutes.defaultValue | should be 4
        }

        It "idleTimeoutInMinutes parameter minValue is 4" {

            $json.parameters.idleTimeoutInMinutes.minValue | should be 4
        }
        
        It "idleTimeoutInMinutes parameter maxValue is 30" {

            $json.parameters.idleTimeoutInMinutes.maxValue | should be 30
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

Describe "Public IP Resource Validation" {

    $publicIp = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/publicIPAddresses" }
    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.Network/publicIPAddresses" {

            $publicIp.type | should be "Microsoft.Network/publicIPAddresses"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-05-01" {

            $publicIp.apiVersion | should be "2020-05-01"
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

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("DDoSProtectionNotifications", "DDoSMitigationFlowLogs", "DDoSMitigationReports")).Length | should be 0
        }
    }
}

Describe "Public IP Output Validation" {

    Context "Public IP Reference Validation" {

        It "type value is object" {

            $json.outputs.publicIP.type | should be "object"
        }

        It "Uses full reference for Public IP" {

            $json.outputs.publicIP.value | should be "[reference(resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIPName')), '2020-05-01', 'Full')]"
        }
    }
}