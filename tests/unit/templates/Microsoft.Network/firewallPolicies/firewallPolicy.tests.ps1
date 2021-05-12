$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Azure Firewall Policy Parameter Validation" {

    Context "firewallPolicyName Validation" {

        It "Has firewallPolicyName parameter" {

            $json.parameters.firewallPolicyName | should not be $null
        }

        It "firewallPolicyName parameter is of type string" {

            $json.parameters.firewallPolicyName.type | should be "string"
        }

        It "firewallPolicyName parameter is mandatory" {

            ($json.parameters.firewallPolicyName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "threatIntelMode Validation" {

        It "Has threatIntelMode parameter" {

            $json.parameters.threatIntelMode | should not be $null
        }

        It "threatIntelMode parameter is of type string" {

            $json.parameters.threatIntelMode.type | should be "string"
        }

        It "threatIntelMode parameter default value is Deny" {

            $json.parameters.threatIntelMode.defaultValue | should be "Deny"
        }

        It "threatIntelMode parameter allowed values are Alert, Deny, Off" {

            (Compare-Object -ReferenceObject $json.parameters.threatIntelMode.allowedValues -DifferenceObject @("Alert", "Deny", "Off")).Length | should be 0
        }
    }

    Context "threatIntelWhitelist Validation" {

        It "Has threatIntelWhitelist parameter" {

            $json.parameters.threatIntelWhitelist | should not be $null
        }

        It "threatIntelWhitelist parameter is of type object" {

            $json.parameters.threatIntelWhitelist.type | should be "object"
        }

        It "threatIntelWhitelist parameter default value is an empty object" {

            $json.parameters.threatIntelWhitelist.defaultValue.PSObject.Properties.Name.Count | should be 0
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

    Context "intrusionDetectionMode Validation" {

        It "Has intrusionDetectionMode parameter" {

            $json.parameters.intrusionDetectionMode | should not be $null
        }

        It "intrusionDetectionMode parameter is of type string" {

            $json.parameters.intrusionDetectionMode.type | should be "string"
        }

        It "intrusionDetectionMode parameter default value is Deny" {

            $json.parameters.intrusionDetectionMode.defaultValue | should be "Deny"
        }

        It "intrusionDetectionMode parameter allowed values are Alert, Deny, Off" {

            (Compare-Object -ReferenceObject $json.parameters.intrusionDetectionMode.allowedValues -DifferenceObject @("Alert", "Deny", "Off")).Length | should be 0
        }
    }

    Context "intrusionDetectionConfiguration Validation" {

        It "Has intrusionDetectionConfiguration parameter" {

            $json.parameters.intrusionDetectionConfiguration | should not be $null
        }

        It "intrusionDetectionConfiguration parameter is of type object" {

            $json.parameters.intrusionDetectionConfiguration.type | should be "object"
        }

        It "intrusionDetectionConfiguration parameter default value is an empty object" {

            $json.parameters.intrusionDetectionConfiguration.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "certificateAuthority Validation" {

        It "Has certificateAuthority parameter" {

            $json.parameters.certificateAuthority | should not be $null
        }

        It "certificateAuthority parameter is of type object" {

            $json.parameters.certificateAuthority.type | should be "object"
        }

        It "certificateAuthority parameter default value is an empty object" {

            $json.parameters.certificateAuthority.defaultValue.PSObject.Properties.Name.Count | should be 0
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

        It "skuTier parameter allowed values are Standard, Premium" {

            (Compare-Object -ReferenceObject $json.parameters.skuTier.allowedValues -DifferenceObject @("Standard", "Premium")).Length | should be 0
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

Describe "Azure Firewall Policy Resource Validation" {

    $policy = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/firewallPolicies" }

    Context "type Validation" {

        It "type value is Microsoft.Network/firewallPolicies" {

            $policy.type | should be "Microsoft.Network/firewallPolicies"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-07-01" {

            $policy.apiVersion | should be "2020-07-01"
        }
    }
}

Describe "Azure Firewall Policy Output Validation" {

    Context "Azure Firewall Policy Reference Validation" {

        It "type value is object" {

            $json.outputs.firewallPolicy.type | should be "object"
        }

        It "Uses full reference for Azure Firewall Policy" {

            $json.outputs.firewallPolicy.value | should be "[reference(resourceId('Microsoft.Network/firewallPolicies', parameters('firewallPolicyName')), '2020-07-01', 'Full')]"
        }
    }
}