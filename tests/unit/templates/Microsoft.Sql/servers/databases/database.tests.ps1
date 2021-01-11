$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "SQL Database Parameter Validation" {

    Context "databaseName Validation" {

        It "Has databaseName parameter" {

            $json.parameters.databaseName | should not be $null
        }

        It "databaseName parameter is of type string" {

            $json.parameters.databaseName.type | should be "string"
        }

        It "databaseName parameter is mandatory" {

            ($json.parameters.databaseName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "sqlServerName Validation" {

        It "Has sqlServerName parameter" {

            $json.parameters.sqlServerName | should not be $null
        }

        It "sqlServerName parameter is of type string" {

            $json.parameters.sqlServerName.type | should be "string"
        }

        It "sqlServerName parameter is mandatory" {

            ($json.parameters.sqlServerName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

        It "sku parameter is of type object" {

            $json.parameters.sku.type | should be "object"
        }

        It "sku parameter is mandatory" {

            ($json.parameters.sku.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "collation Validation" {

        It "Has collation parameter" {

            $json.parameters.collation | should not be $null
        }

        It "collation parameter is of type string" {

            $json.parameters.collation.type | should be "string"
        }

        It "collation parameter default value is SQL_Latin1_General_CP1_CI_AS" {

            $json.parameters.collation.defaultValue | should be "SQL_Latin1_General_CP1_CI_AS"
        }

        It "collation parameter allowed values are DATABASE_DEFAULT, SQL_Latin1_General_CP1_CI_AS" {

            (Compare-Object -ReferenceObject $json.parameters.collation.allowedValues -DifferenceObject @("DATABASE_DEFAULT", "SQL_Latin1_General_CP1_CI_AS")).Length | should be 0
        }
    }

    Context "maxSizeBytes Validation" {

        It "Has maxSizeBytes parameter" {

            $json.parameters.maxSizeBytes | should not be $null
        }

        It "maxSizeBytes parameter is of type int" {

            $json.parameters.maxSizeBytes.type | should be "int"
        }

        It "maxSizeBytes parameter default value is 34359738368" {

            $json.parameters.maxSizeBytes.defaultValue | should be 34359738368
        }
    }

    Context "elasticPoolSubscriptionId Validation" {

        It "Has elasticPoolSubscriptionId parameter" {

            $json.parameters.elasticPoolSubscriptionId | should not be $null
        }

        It "elasticPoolSubscriptionId parameter is of type string" {

            $json.parameters.elasticPoolSubscriptionId.type | should be "string"
        }

        It "elasticPoolSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.elasticPoolSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "elasticPoolResourceGroupName Validation" {

        It "Has elasticPoolResourceGroupName parameter" {

            $json.parameters.elasticPoolResourceGroupName | should not be $null
        }

        It "elasticPoolResourceGroupName parameter is of type string" {

            $json.parameters.elasticPoolResourceGroupName.type | should be "string"
        }

        It "elasticPoolResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.elasticPoolResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "elasticPoolName Validation" {

        It "Has elasticPoolName parameter" {

            $json.parameters.elasticPoolName | should not be $null
        }

        It "elasticPoolName parameter is of type string" {

            $json.parameters.elasticPoolName.type | should be "string"
        }

        It "elasticPoolName parameter default value is an empty string" {

            $json.parameters.elasticPoolName.defaultValue | should be ([String]::Empty)
        }
    }

    Context "catalogCollation Validation" {

        It "Has catalogCollation parameter" {

            $json.parameters.catalogCollation | should not be $null
        }

        It "catalogCollation parameter is of type string" {

            $json.parameters.catalogCollation.type | should be "string"
        }

        It "catalogCollation parameter default value is SQL_Latin1_General_CP1_CI_AS" {

            $json.parameters.catalogCollation.defaultValue | should be "SQL_Latin1_General_CP1_CI_AS"
        }

        It "catalogCollation parameter allowed values are DATABASE_DEFAULT, SQL_Latin1_General_CP1_CI_AS" {

            (Compare-Object -ReferenceObject $json.parameters.catalogCollation.allowedValues -DifferenceObject @("DATABASE_DEFAULT", "SQL_Latin1_General_CP1_CI_AS")).Length | should be 0
        }
    }

    Context "zoneRedundant Validation" {

        It "Has zoneRedundant parameter" {

            $json.parameters.zoneRedundant | should not be $null
        }

        It "zoneRedundant parameter is of type bool" {

            $json.parameters.zoneRedundant.type | should be "bool"
        }

        It "zoneRedundant parameter default value is true" {

            $json.parameters.zoneRedundant.defaultValue | should be $true
        }
    }

    Context "licenseType Validation" {

        It "Has licenseType parameter" {

            $json.parameters.licenseType | should not be $null
        }

        It "licenseType parameter is of type string" {

            $json.parameters.licenseType.type | should be "string"
        }

        It "licenseType parameter default value is LicenseIncluded" {

            $json.parameters.licenseType.defaultValue | should be "LicenseIncluded"
        }

        It "licenseType parameter allowed values are LicenseIncluded, BasePrice" {

            (Compare-Object -ReferenceObject $json.parameters.licenseType.allowedValues -DifferenceObject @("LicenseIncluded", "BasePrice")).Length | should be 0
        }
    }

    Context "autoPauseDelay Validation" {

        It "Has autoPauseDelay parameter" {

            $json.parameters.autoPauseDelay | should not be $null
        }

        It "autoPauseDelay parameter is of type int" {

            $json.parameters.autoPauseDelay.type | should be "int"
        }

        It "autoPauseDelay parameter default value is -1" {

            $json.parameters.autoPauseDelay.defaultValue | should be -1
        }
    }

    Context "minCapacity Validation" {

        It "Has minCapacity parameter" {

            $json.parameters.minCapacity | should not be $null
        }

        It "minCapacity parameter is of type string" {

            $json.parameters.minCapacity.type | should be "string"
        }

        It "minCapacity parameter default value is 2" {

            $json.parameters.minCapacity.defaultValue | should be "2"
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

Describe "SQL Database Resource Validation" {

    $database = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Sql/servers/databases" }
    $transparentDataEncryption = $database.resources | Where-Object { $PSItem.type -eq "transparentDataEncryption" }

    Context "apiVersion Validation" {

        It "apiVersion value is 2017-10-01-preview" {

            $database.apiVersion | should be "2017-10-01-preview"
        }
    }

    Context "createMode Validation" {

        It "createMode value is Default" {

            $database.properties.createMode | should be "Default"
        }
    }

    Context "Transparent Data Encryption Validation" {


        It "apiVersion value is 2014-04-01" {

            $transparentDataEncryption.apiVersion | should be "2014-04-01"
        }

        It "status is Enabled" {

            $transparentDataEncryption.properties.status | should be "Enabled"
        }
    }
}

Describe "SQL Database Output Validation" {

    Context "SQL Database Reference Validation" {

        It "type value is object" {

            $json.outputs.database.type | should be "object"
        }

        It "Uses full reference for SQL Database" {

            $json.outputs.database.value | should be "[reference(resourceId('Microsoft.Sql/servers/databases', parameters('sqlServerName'), parameters('databaseName')), '2017-10-01-preview', 'Full')]"
        }
    }
}