$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "SQL Server Parameter Validation" {

    Context "sqlserverName Validation" {

        It "Has sqlserverName parameter" {

            $json.parameters.sqlserverName | should not be $null
        }

        It "sqlserverName parameter is of type string" {

            $json.parameters.sqlserverName.type | should be "string"
        }

        It "sqlserverName parameter is mandatory" {

            ($json.parameters.sqlserverName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "administratorLogin Validation" {

        It "Has administratorLogin parameter" {

            $json.parameters.administratorLogin | should not be $null
        }

        It "administratorLogin parameter is of type string" {

            $json.parameters.administratorLogin.type | should be "string"
        }

        It "administratorLogin parameter default value is StorageV2" {

            $json.parameters.administratorLogin.defaultValue | should be "sqladmin"
        }
    }

    Context "administratorLoginPassword Validation" {

        It "Has administratorLoginPassword parameter" {

            $json.parameters.administratorLoginPassword | should not be $null
        }

        It "administratorLoginPassword parameter is of type securestring" {

            $json.parameters.administratorLoginPassword.type | should be "securestring"
        }

        It "administratorLoginPassword parameter is mandatory" {

            ($json.parameters.administratorLoginPassword.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "firewallRules Validation" {

        It "Has firewallRules parameter" {

            $json.parameters.firewallRules | should not be $null
        }

        It "firewallRules parameter is of type array" {

            $json.parameters.firewallRules.type | should be "array"
        }

        It "firewallRules parameter is mandatory" {

            ($json.parameters.firewallRules.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "securityAlertPolicyState Validation" {

        It "Has securityAlertPolicyState parameter" {

            $json.parameters.securityAlertPolicyState | should not be $null
        }

        It "securityAlertPolicyState parameter is of type string" {

            $json.parameters.securityAlertPolicyState.type | should be "string"
        }

        It "securityAlertPolicyState parameter default value is Enabled" {

            $json.parameters.securityAlertPolicyState.defaultValue | should be "Enabled"
        }

        It "securityAlertPolicyState parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.securityAlertPolicyState.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "emailAddresses Validation" {

        It "Has emailAddresses parameter" {

            $json.parameters.emailAddresses | should not be $null
        }

        It "emailAddresses parameter is of type array" {

            $json.parameters.emailAddresses.type | should be "array"
        }

        It "emailAddresses parameter is mandatory" {

            ($json.parameters.emailAddresses.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "aadLoginName Validation" {

        It "Has aadLoginName parameter" {

            $json.parameters.aadLoginName | should not be $null
        }

        It "aadLoginName parameter is of type string" {

            $json.parameters.aadLoginName.type | should be "string"
        }

        It "aadLoginName parameter is mandatory" {

            ($json.parameters.aadLoginName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "aadObjectId Validation" {

        It "Has aadObjectId parameter" {

            $json.parameters.aadObjectId | should not be $null
        }

        It "aadObjectId parameter is of type securestring" {

            $json.parameters.aadObjectId.type | should be "securestring"
        }

        It "aadObjectId parameter is mandatory" {

            ($json.parameters.aadObjectId.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "threatDetectionStorageAccountSubscriptionId Validation" {

        It "Has threatDetectionStorageAccountSubscriptionId parameter" {

            $json.parameters.threatDetectionStorageAccountSubscriptionId | should not be $null
        }

        It "threatDetectionStorageAccountSubscriptionId parameter is of type string" {

            $json.parameters.threatDetectionStorageAccountSubscriptionId.type | should be "string"
        }

        It "threatDetectionStorageAccountSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.threatDetectionStorageAccountSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "threatDetectionStorageAccountResourceGroupName Validation" {

        It "Has threatDetectionStorageAccountResourceGroupName parameter" {

            $json.parameters.threatDetectionStorageAccountResourceGroupName | should not be $null
        }

        It "threatDetectionStorageAccountResourceGroupName parameter is of type string" {

            $json.parameters.threatDetectionStorageAccountResourceGroupName.type | should be "string"
        }

        It "threatDetectionStorageAccountResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.threatDetectionStorageAccountResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "threatDetectionStorageAccountName Validation" {

        It "Has threatDetectionStorageAccountName parameter" {

            $json.parameters.threatDetectionStorageAccountName | should not be $null
        }

        It "threatDetectionStorageAccountName parameter is of type string" {

            $json.parameters.threatDetectionStorageAccountName.type | should be "string"
        }

        It "threatDetectionStorageAccountName parameter is mandatory" {

            ($json.parameters.threatDetectionStorageAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "SQL Server Resource Validation" {

    $server = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Sql/servers" }
    $master = $server.resources | Where-Object { $PSItem.type -eq "databases" }
    $securityAlertPolicy = $master.resources | Where-Object { $PSItem.type -eq "securityAlertPolicies" }
    $vulnerabilityAssessment = $master.resources | Where-Object { $PSItem.type -eq "vulnerabilityAssessments" }
    $diagnostics = $master.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }
    $auditingSettings = $server.resources | Where-Object { $PSItem.type -eq "auditingSettings" }
    $activeDirectoryAdmins = $server.resources | Where-Object { $PSItem.type -eq "administrators" }
    $firewallRules = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Sql/servers/firewallRules" }

    Context "type Validation" {

        It "type value is Microsoft.Sql/servers" {

            $server.type | should be "Microsoft.Sql/servers"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-05-01-preview" {

            $server.apiVersion | should be "2015-05-01-preview"
        }
    }

    Context "Managed Service Identity Validation" {

        It "Managed Service Identity is SystemAssigned" {

            $server.identity.type -eq "SystemAssigned" | should be $true
        }
    }

    Context "Master Database Validation" {

        It "Database name is master" {
            $master.name | should be "master"
        }

        It "apiVersion value is 2017-10-01-preview" {
            $master.apiVersion | should be "2017-10-01-preview"
        }
    }

    Context "Security Alert Policy Validation" {

        It "securityAlertPolicy name is Default" {
            $securityAlertPolicy.name | should be "Default"
        }

        It "apiVersion value is 2018-06-01-preview" {
            $securityAlertPolicy.apiVersion | should be "2018-06-01-preview"
        }

        It "disabledAlerts is an empty array" {
            $securityAlertPolicy.properties.disabledAlerts | should be @()
        }

        It "emailAccountAdmins is true" {
            $securityAlertPolicy.properties.emailAccountAdmins | should be $true
        }

        It "retentionsDays is 365" {
            $securityAlertPolicy.properties.retentionDays | should be 365
        }
    }

    Context "Vulnerability Assessment Validation" {

        It "vulnerabilityAssessment name is Default" {
            $vulnerabilityAssessment.name | should be "Default"
        }

        It "apiVersion value is 2017-03-01-preview" {
            $vulnerabilityAssessment.apiVersion | should be "2017-03-01-preview"
        }

        It "Recurring scans isEnabled is true" {
            $vulnerabilityAssessment.properties.recurringScans.isEnabled | should be true
        }

        It "Recurring scans emailSubscriptionAdmins is true" {
            $vulnerabilityAssessment.properties.recurringScans.emailSubscriptionAdmins | should be true
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is /providers/diagnosticSettings" {

            $diagnostics.type | should be "/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $diagnostics.apiVersion | should be "2015-07-01"
        }

        It "All metrics are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.metrics.category -DifferenceObject @("Basic", "InstanceAndAppAdvanced")).Length | should be 0
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("SQLInsights", "AutomaticTuning", "QueryStoreRuntimeStatistics", "QueryStoreWaitStatistics", "Errors", "DatabaseWaitStatistics", "Timeouts", "Blocks", "Deadlocks", "Audit", "SQLSecurityAuditEvents")).Length | should be 0
        }
    }

    Context "Auditing Settings Validation" {

        It "auditingSettings name is Default" {
            $auditingSettings.name | should be "Default"
        }

        It "apiVersion value is 2017-03-01-preview" {
            $auditingSettings.apiVersion | should be "2017-03-01-preview"
        }

        It "state is Enabled" {
            $auditingSettings.properties.state | should be "Enabled"
        }

        It "retentionDays is 365" {
            $auditingSettings.properties.retentionDays | should be 365
        }

        It "auditActionsAndGroups is SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP, FAILED_DATABASE_AUTHENTICATION_GROUP, BATCH_COMPLETED_GROUP" {
            (Compare-Object -ReferenceObject $auditingSettings.properties.auditActionsAndGroups -DifferenceObject @("SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP", "FAILED_DATABASE_AUTHENTICATION_GROUP", "BATCH_COMPLETED_GROUP")).Length | should be 0
        }

        It "isAzureMonitorTargetEnabled is true" {
            $auditingSettings.properties.isAzureMonitorTargetEnabled | should be $true
        }
    }

    Context "Active Directory Validation" {

        It "administrators name is activeDirectory" {
            $activeDirectoryAdmins.name | should be "activeDirectory"
        }

        It "apiVersion value is 2014-04-01" {
            $activeDirectoryAdmins.apiVersion | should be "2014-04-01"
        }

        It "administratorType is ActiveDirectory" {
            $activeDirectoryAdmins.properties.administratorType | should be "ActiveDirectory"
        }

        It "tenantId is [subscription().tenantId]" {
            $activeDirectoryAdmins.properties.tenantId | should be "[subscription().tenantId]"
        }
    }

    Context "Firewall Rules Validation" {

        It "apiVersion value is 2014-04-01" {
            $firewallRules.apiVersion | should be "2014-04-01"
        }
    }
}

Describe "SQL Server Output Validation" {

    Context "SQL Server Reference Validation" {

        It "type value is object" {

            $json.outputs.sqlServer.type | should be "object"
        }

        It "Uses full reference for SQL Server" {

            $json.outputs.sqlServer.value | should be "[reference(resourceId('Microsoft.Sql/servers', parameters('sqlServerName')), '2015-05-01-preview', 'Full')]"
        }
    }
}