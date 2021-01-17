$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Log Analytics Workspace Parameter Validation" {

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

    Context "sku Validation" {

        It "Has sku parameter" {

            $json.parameters.sku | should not be $null
        }

        It "sku parameter is of type string" {

            $json.parameters.sku.type | should be "string"
        }

        It "sku parameter default value is PerGB2018" {

            $json.parameters.sku.defaultValue | should be "PerGB2018"
        }

        It "sku parameter allowed values are Free, Standard, Premium, PerNode, PerGB2018, Standalone, CapacityReservation" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Free", "Standard", "Premium", "PerNode", "PerGB2018", "Standalone", "CapacityReservation")).Length | should be 0
        }
    }

    Context "capacityReservationLevel Validation" {

        It "Has capacityReservationLevel parameter" {

            $json.parameters.capacityReservationLevel | should not be $null
        }

        It "capacityReservationLevel parameter is of type int" {

            $json.parameters.capacityReservationLevel.type | should be "int"
        }

        It "capacityReservationLevel parameter default value is 0" {

            $json.parameters.capacityReservationLevel.defaultValue | should be 0
        }
    }

    Context "retentionInDays Validation" {

        It "Has retentionInDays parameter" {

            $json.parameters.retentionInDays | should not be $null
        }

        It "retentionInDays parameter is of type int" {

            $json.parameters.retentionInDays.type | should be "int"
        }

        It "retentionInDays parameter default value is 400" {

            $json.parameters.retentionInDays.defaultValue | should be 400
        }

        It "retentionInDays parameter minimum value is 30" {

            $json.parameters.retentionInDays.minValue | should be 30
        }

        It "retentionInDays parameter maximum value is 730" {

            $json.parameters.retentionInDays.maxValue | should be 730
        }
    }

    Context "dailyQuotaGB Validation" {

        It "Has dailyQuotaGB parameter" {

            $json.parameters.dailyQuotaGB | should not be $null
        }

        It "dailyQuotaGB parameter is of type string" {

            $json.parameters.dailyQuotaGB.type | should be "string"
        }

        It "dailyQuotaGB parameter default value is an empty string" {

            $json.parameters.dailyQuotaGB.defaultValue | should be ([String]::Empty)
        }
    }

    Context "publicNetworkAccessForIngestion Validation" {

        It "Has publicNetworkAccessForIngestion parameter" {

            $json.parameters.publicNetworkAccessForIngestion | should not be $null
        }

        It "publicNetworkAccessForIngestion parameter is of type string" {

            $json.parameters.publicNetworkAccessForIngestion.type | should be "string"
        }

        It "publicNetworkAccessForIngestion parameter default value is Enabled" {

            $json.parameters.publicNetworkAccessForIngestion.defaultValue | should be "Enabled"
        }

        It "publicNetworkAccessForIngestion parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.publicNetworkAccessForIngestion.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "publicNetworkAccessForQuery Validation" {

        It "Has publicNetworkAccessForQuery parameter" {

            $json.parameters.publicNetworkAccessForQuery | should not be $null
        }

        It "publicNetworkAccessForQuery parameter is of type string" {

            $json.parameters.publicNetworkAccessForQuery.type | should be "string"
        }

        It "publicNetworkAccessForQuery parameter default value is Enabled" {

            $json.parameters.publicNetworkAccessForQuery.defaultValue | should be "Enabled"
        }

        It "publicNetworkAccessForQuery parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.publicNetworkAccessForQuery.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
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

Describe "Log Analytics Workspace Validation" {

    $workspace = $json.resources | Where-Object { $PSItem.Type -eq "Microsoft.OperationalInsights/workspaces" }
    
    Context "type Validation" {

        It "type value is Microsoft.OperationalInsights/workspaces" {

            $workspace.type | should be "Microsoft.OperationalInsights/workspaces"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-08-01" {

            $workspace.apiVersion | should be "2020-08-01"
        }
    }

    Context "location Validation" {

        It "location is westeurope" {

            $workspace.location -eq "westeurope" | should be $true
        }
    }
}

Describe "Log Analytics Workspace Output Validation" {

    Context "Log Analytics Workspace Reference Validation" {

        It "type value is object" {

            $json.outputs.logAnalytics.type | should be "object"
        }

        It "Uses full reference for Log Analytics Workspace" {

            $json.outputs.logAnalytics.value | should be "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('logAnalyticsName')), '2020-08-01', 'Full')]"
        }
    }
}