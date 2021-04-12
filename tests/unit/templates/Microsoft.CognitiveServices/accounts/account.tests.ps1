$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Cognitive Services Parameter Validation" {

  Context "accountName Validation" {

    It "Has accountName parameter" {

      $json.parameters.accountName | should not be $null
    }

    It "accountName parameter is of type string" {

      $json.parameters.accountName.type | should be "string"
    }

    It "accountName parameter is mandatory" {

      ($json.parameters.accountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

  Context "customSubDomainName Validation" {

    It "Has customSubDomainName parameter" {

      $json.parameters.customSubDomainName | should not be $null
    }

    It "customSubDomainName parameter is of type string" {

      $json.parameters.customSubDomainName.type | should be "string"
    }

    It "customSubDomainName parameter default value is an empty string" {

      $json.parameters.customSubDomainName.defaultValue | should be ([string]::Empty)
    }
  }

  Context "privateEndpointConnections Validation" {

    It "Has privateEndpointConnections parameter" {

      $json.parameters.privateEndpointConnections | should not be $null
    }

    It "privateEndpointConnections parameter is of type array" {

      $json.parameters.privateEndpointConnections.type | should be "array"
    }

    It "privateEndpointConnections parameter default value is an empty array" {

      $json.parameters.privateEndpointConnections.defaultValue.Count | should be 0
    }
  }

  Context "publicNetworkAccess Validation" {

    It "Has publicNetworkAccess parameter" {

      $json.parameters.publicNetworkAccess | should not be $null
    }

    It "publicNetworkAccess parameter is of type string" {

      $json.parameters.publicNetworkAccess.type | should be "string"
    }

    It "publicNetworkAccess parameter default value is Enabled" {

      $json.parameters.publicNetworkAccess.defaultValue | should be "Enabled"
    }

    It "publicNetworkAccess parameter allowed values are Enabled, Disabled" {

      (Compare-Object -ReferenceObject $json.parameters.publicNetworkAccess.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
    }
  }

  Context "apiProperties Validation" {

    It "Has apiProperties parameter" {

      $json.parameters.apiProperties | should not be $null
    }

    It "apiProperties parameter is of type secureobject" {

      $json.parameters.apiProperties.type | should be "secureobject"
    }

    It "apiProperties parameter default value is an empty secureobject" {

      $json.parameters.apiProperties.defaultValue.PSObject.Properties.Name.Count | should be 0
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

Describe "Cognitive Services Resource Validation" {

  $account = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.CognitiveServices/accounts" }
  $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

  Context "type Validation" {

    It "type value is Microsoft.CognitiveServices/accounts" {

      $account.type | should be "Microsoft.CognitiveServices/accounts"
    }
  }

  Context "apiVersion Validation" {

    It "apiVersion value is 2017-04-18" {

      $account.apiVersion | should be "2017-04-18"
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

      (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("Audit", "RequestResponse", "Trace")).Length | should be 0
    }
  }
}

Describe "Cognitive Services Output Validation" {

  Context "Cognitive Services Reference Validation" {

    It "type value is object" {

      $json.outputs.account.type | should be "object"
    }

    It "Uses full reference for Cognitive Services" {

      $json.outputs.account.value | should be "[reference(resourceId('Microsoft.CognitiveServices/accounts', parameters('accountName')), '2017-04-18', 'Full')]"
    }
  }
}