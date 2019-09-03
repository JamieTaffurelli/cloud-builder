$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
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

        It "sku parameter allowed values are Free, Standard, Premium, Unlimited, PerNode, PerGB2018, Standalone" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Free", "Standard", "Premium", "Unlimited", "PerNode", "PerGB2018", "Standalone")).Length | should be 0
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

        It "retentionInDays parameter minimum value is 10" {

            $json.parameters.retentionInDays.minValue | should be 10
        }

        It "retentionInDays parameter maximum value is 730" {

            $json.parameters.retentionInDays.maxValue | should be 730
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

        It "apiVersion value is 2015-11-01-preview" {

            $workspace.apiVersion | should be "2015-11-01-preview"
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

            $json.outputs.logAnalytics.value | should be "[reference(resourceId('Microsoft.OperationalInsights/workspaces', parameters('logAnalyticsName')), '2015-11-01-preview', 'Full')]"
        }
    }
}