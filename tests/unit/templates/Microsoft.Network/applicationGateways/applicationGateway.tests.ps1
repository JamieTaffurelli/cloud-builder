$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Gateway Parameter Validation" {

    Context "appGatewayName Validation" {

        It "Has appGatewayName parameter" {

            $json.parameters.appGatewayName | should not be $null
        }

        It "appGatewayName parameter is of type string" {

            $json.parameters.appGatewayName.type | should be "string"
        }

        It "appGatewayName parameter is mandatory" {

            ($json.parameters.appGatewayName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "appGatewayName parameter minimum length is 1" {

            $json.parameters.appGatewayName.minLength | should be 1
        }

        It "appGatewayName parameter maximum length is 80" {

            $json.parameters.appGatewayName.maxLength | should be 80
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

        It "skuName parameter default value is WAF_Medium" {

            $json.parameters.skuName.defaultValue | should be "WAF_Medium"
        }

        It "skuName parameter allowed values are 'WAF_Medium', 'WAF_Large', 'WAF_v2'" {

            (Compare-Object -ReferenceObject $json.parameters.skuName.allowedValues -DifferenceObject @("WAF_Medium", "WAF_Large", "WAF_v2")).Length | should be 0
        }
    }

    Context "capacity Validation" {

        It "Has capacity parameter" {

            $json.parameters.capacity | should not be $null
        }

        It "capacity parameter is of type int" {

            $json.parameters.capacity.type | should be "int"
        }

        It "capacity parameter default value is 2" {

            $json.parameters.capacity.defaultValue | should be 2
        }

        It "capacity parameter minimum value is 1" {

            $json.parameters.capacity.minValue | should be 0
        }

        It "capacity parameter maximum value is 125" {

            $json.parameters.capacity.maxValue | should be 125
        }
    }

    Context "gatewayIpConfigurations Validation" {

        It "Has gatewayIpConfigurations parameter" {

            $json.parameters.gatewayIpConfigurations | should not be $null
        }

        It "gatewayIpConfigurations parameter is of type array" {

            $json.parameters.gatewayIpConfigurations.type | should be "array"
        }

        It "gatewayIpConfigurations parameter is mandatory" {

            ($json.parameters.appGatewayName.PSObject.Properties.Name -contains "gatewayIpConfigurations") | should be $false
        }
    }

    Context "authenticationCertificates Validation" {

        It "Has authenticationCertificates parameter" {

            $json.parameters.authenticationCertificates | should not be $null
        }

        It "authenticationCertificates parameter is of type array" {

            $json.parameters.authenticationCertificates.type | should be "array"
        }

        It "authenticationCertificates parameter default value is an empty array" {

            $json.parameters.authenticationCertificates.defaultValue | should be @()
        }
    }

    Context "trustedRootCertificates Validation" {

        It "Has trustedRootCertificates parameter" {

            $json.parameters.trustedRootCertificates | should not be $null
        }

        It "trustedRootCertificates parameter is of type array" {

            $json.parameters.trustedRootCertificates.type | should be "array"
        }

        It "trustedRootCertificates parameter default value is an empty array" {

            $json.parameters.trustedRootCertificates.defaultValue | should be @()
        }

        It "trustedRootCertificates parameter maximum value is 100" {

            $json.parameters.trustedRootCertificates.maxLength | should be 100
        }
    }

    Context "sslCertificates Validation" {

        It "Has sslCertificates parameter" {

            $json.parameters.sslCertificates | should not be $null
        }

        It "sslCertificates parameter is of type array" {

            $json.parameters.sslCertificates.type | should be "array"
        }

        It "sslCertificates parameter default value is an empty array" {

            $json.parameters.sslCertificates.defaultValue | should be @()
        }

        It "sslCertificates parameter maximum value is 100" {

            $json.parameters.sslCertificates.maxLength | should be 100
        }
    }

    Context "frontendIPConfigurations Validation" {

        It "Has frontendIPConfigurations parameter" {

            $json.parameters.frontendIPConfigurations | should not be $null
        }

        It "frontendIPConfigurations parameter is of type array" {

            $json.parameters.frontendIPConfigurations.type | should be "array"
        }

        It "frontendIPConfigurations parameter is mandatory" {

            ($json.parameters.frontendIPConfigurations.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "frontendIPConfigurations parameter minimum length is 1" {

            $json.parameters.frontendIPConfigurations.minLength | should be 1
        }

        It "frontendIPConfigurations parameter maximum length is 2" {

            $json.parameters.frontendIPConfigurations.maxLength | should be 2
        }
    }

    Context "frontendPorts Validation" {

        It "Has frontendPorts parameter" {

            $json.parameters.frontendPorts | should not be $null
        }

        It "frontendPorts parameter is of type array" {

            $json.parameters.frontendPorts.type | should be "array"
        }

        It "frontendPorts parameter is mandatory" {

            ($json.parameters.frontendPorts.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "frontendPorts parameter minimum length is 1" {

            $json.parameters.frontendPorts.minLength | should be 1
        }

        It "frontendPorts parameter maximum length is 100" {

            $json.parameters.frontendPorts.maxLength | should be 100
        }
    }

    Context "probes Validation" {

        It "Has probes parameter" {

            $json.parameters.probes | should not be $null
        }

        It "probes parameter is of type array" {

            $json.parameters.probes.type | should be "array"
        }

        It "probes parameter default value is an empty array" {

            $json.parameters.probes.defaultValue | should be @()
        }
    }

    Context "backendAddressPools Validation" {

        It "Has backendAddressPools parameter" {

            $json.parameters.backendAddressPools | should not be $null
        }

        It "backendAddressPools parameter is of type array" {

            $json.parameters.backendAddressPools.type | should be "array"
        }

        It "backendAddressPools parameter is mandatory" {

            ($json.parameters.backendAddressPools.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "backendAddressPools parameter minimum length is 1" {

            $json.parameters.backendAddressPools.minLength | should be 1
        }

        It "backendAddressPools parameter maximum length is 100" {

            $json.parameters.backendAddressPools.maxLength | should be 100
        }
    }

    Context "backendHttpSettingsCollection Validation" {

        It "Has backendHttpSettingsCollection parameter" {

            $json.parameters.backendHttpSettingsCollection | should not be $null
        }

        It "backendHttpSettingsCollection parameter is of type array" {

            $json.parameters.backendHttpSettingsCollection.type | should be "array"
        }

        It "backendHttpSettingsCollection parameter is mandatory" {

            ($json.parameters.backendHttpSettingsCollection.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "backendHttpSettingsCollection parameter minimum length is 1" {

            $json.parameters.backendHttpSettingsCollection.minLength | should be 1
        }

        It "backendHttpSettingsCollection parameter maximum length is 100" {

            $json.parameters.backendHttpSettingsCollection.maxLength | should be 100
        }
    }

    Context "httpListeners Validation" {

        It "Has httpListeners parameter" {

            $json.parameters.httpListeners | should not be $null
        }

        It "httpListeners parameter is of type array" {

            $json.parameters.httpListeners.type | should be "array"
        }

        It "httpListeners parameter is mandatory" {

            ($json.parameters.httpListeners.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "httpListeners parameter minimum length is 1" {

            $json.parameters.httpListeners.minLength | should be 1
        }

        It "httpListeners parameter maximum length is 100" {

            $json.parameters.httpListeners.maxLength | should be 100
        }
    }

    Context "urlPathMaps Validation" {

        It "Has urlPathMaps parameter" {

            $json.parameters.urlPathMaps | should not be $null
        }

        It "urlPathMaps parameter is of type array" {

            $json.parameters.urlPathMaps.type | should be "array"
        }

        It "urlPathMaps parameter default value is an empty array" {

            $json.parameters.urlPathMaps.defaultValue | should be @()
        }
    }

    Context "requestRoutingRules Validation" {

        It "Has requestRoutingRules parameter" {

            $json.parameters.requestRoutingRules | should not be $null
        }

        It "requestRoutingRules parameter is of type array" {

            $json.parameters.requestRoutingRules.type | should be "array"
        }

        It "requestRoutingRules parameter default value is an empty array" {

            $json.parameters.requestRoutingRules.defaultValue | should be @()
        }
    }

    Context "rewriteRuleSets Validation" {

        It "Has rewriteRuleSets parameter" {

            $json.parameters.rewriteRuleSets | should not be $null
        }

        It "requestRoutingRules parameter is of type array" {

            $json.parameters.rewriteRuleSets.type | should be "array"
        }

        It "rewriteRuleSets parameter default value is an empty array" {

            $json.parameters.rewriteRuleSets.defaultValue | should be @()
        }
    }

    Context "redirectConfigurations Validation" {

        It "Has redirectConfigurations parameter" {

            $json.parameters.redirectConfigurations | should not be $null
        }

        It "redirectConfigurations parameter is of type array" {

            $json.parameters.redirectConfigurations.type | should be "array"
        }

        It "redirectConfigurations parameter default value is an empty array" {

            $json.parameters.redirectConfigurations.defaultValue | should be @()
        }
    }

    Context "firewallMode Validation" {

        It "Has firewallMode parameter" {

            $json.parameters.firewallMode | should not be $null
        }

        It "firewallMode parameter is of type string" {

            $json.parameters.firewallMode.type | should be "string"
        }

        It "firewallMode parameter default value is Prevention" {

            $json.parameters.firewallMode.defaultValue | should be "Prevention"
        }

        It "firewallMode parameter allowed values are 'Detection', 'Prevention'" {

            (Compare-Object -ReferenceObject $json.parameters.firewallMode.allowedValues -DifferenceObject @("Detection", "Prevention")).Length | should be 0
        }
    }

    Context "maxRequestBodySizeInKb Validation" {

        It "Has maxRequestBodySizeInKb parameter" {

            $json.parameters.maxRequestBodySizeInKb | should not be $null
        }

        It "maxRequestBodySizeInKb parameter is of type int" {

            $json.parameters.maxRequestBodySizeInKb.type | should be "int"
        }

        It "maxRequestBodySizeInKb parameter default value is 128" {

            $json.parameters.maxRequestBodySizeInKb.defaultValue | should be 128
        }

        It "maxRequestBodySizeInKb parameter minimum value is 1" {

            $json.parameters.maxRequestBodySizeInKb.minValue | should be 1
        }

        It "maxRequestBodySizeInKb parameter maximum value is 128" {

            $json.parameters.maxRequestBodySizeInKb.maxValue | should be 128
        }
    }

    Context "fileUploadLimitInMb Validation" {

        It "Has fileUploadLimitInMb parameter" {

            $json.parameters.fileUploadLimitInMb | should not be $null
        }

        It "fileUploadLimitInMb parameter is of type int" {

            $json.parameters.fileUploadLimitInMb.type | should be "int"
        }

        It "fileUploadLimitInMb parameter default value is 100" {

            $json.parameters.fileUploadLimitInMb.defaultValue | should be 100
        }

        It "fileUploadLimitInMb parameter minimum value is 1" {

            $json.parameters.fileUploadLimitInMb.minValue | should be 1
        }

        It "fileUploadLimitInMb parameter maximum value is 500" {

            $json.parameters.fileUploadLimitInMb.maxValue | should be 500
        }
    }

    Context "exclusions Validation" {

        It "Has exclusions parameter" {

            $json.parameters.exclusions | should not be $null
        }

        It "exclusions parameter is of type array" {

            $json.parameters.exclusions.type | should be "array"
        }

        It "exclusions parameter default value is an empty array" {

            $json.parameters.exclusions.defaultValue | should be @()
        }
    }

    Context "autoScaleConfiguration Validation" {

        It "Has autoScaleConfiguration parameter" {

            $json.parameters.autoScaleConfiguration | should not be $null
        }

        It "autoScaleConfiguration parameter is of type object" {

            $json.parameters.autoScaleConfiguration.type | should be "object"
        }

        It "autoScaleConfiguration parameter default value is an empty object" {

            $json.parameters.autoScaleConfiguration.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "customErrorConfigurations Validation" {

        It "Has customErrorConfigurations parameter" {

            $json.parameters.customErrorConfigurations | should not be $null
        }

        It "customErrorConfigurations parameter is of type array" {

            $json.parameters.customErrorConfigurations.type | should be "array"
        }

        It "customErrorConfigurations parameter default value is an empty array" {

            $json.parameters.customErrorConfigurations.defaultValue | should be @()
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

Describe "Application Gateway Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Network/applicationGateways" {

            $json.resources.type | should be "Microsoft.Network/applicationGateways"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }

    Context "SSL Policy Validation" {

        It "policyType is predefined" {

            $json.resources.properties.sslpolicy.policyType | should be "Predefined"
        }

        It "policyName is AppGwSslPolicy20170401S" {

            $json.resources.properties.sslpolicy.policyName | should be "AppGwSslPolicy20170401S"
        }
    }

    Context "Web Application Firewall Validation" {

        It "WAF is enabled" {

            $json.resources.properties.webApplicationFirewallConfiguration.enabled | should be $true
        }

        It "WAF rule set is OWASP" {

            $json.resources.properties.webApplicationFirewallConfiguration.ruleSetType | should be "OWASP"
        }

        It "WAF rule set version is 3.0" {

            $json.resources.properties.webApplicationFirewallConfiguration.ruleSetVersion | should be "3.0"
        }

        It "WAF request body check is enabled" {

            $json.resources.properties.webApplicationFirewallConfiguration.requestBodyCheck | should be $true
        }
    }

    Context "HTTP Version Validation" {

        It "HTTP2 is enabled" {

            $json.resources.properties.enableHttp2 | should be $true
        }
    }
}

Describe "Application Gateway Output Validation" {

    Context "Application Gateway Reference Validation" {

        It "type value is object" {

            $json.outputs.applicationGateway.type | should be "object"
        }

        It "Uses full reference for Application Gateway" {

            $json.outputs.applicationGateway.value | should be "[reference(resourceId('Microsoft.Network/applicationGateways', parameters('appGatewayName')), '2019-04-01', 'Full')]"
        }
    }
}