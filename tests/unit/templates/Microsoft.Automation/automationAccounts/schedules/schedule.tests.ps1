$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Schedule Parameter Validation" {

    Context "scheduleName Validation" {

        It "Has scheduleName parameter" {

            $json.parameters.scheduleName | should not be $null
        }

        It "scheduleName parameter is of type string" {

            $json.parameters.scheduleName.type | should be "string"
        }

        It "scheduleName parameter is mandatory" {

            ($json.parameters.scheduleName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "automationAccountName Validation" {

        It "Has automationAccountName parameter" {

            $json.parameters.automationAccountName | should not be $null
        }

        It "automationAccountName parameter is of type string" {

            $json.parameters.automationAccountName.type | should be "string"
        }

        It "automationAccountName parameter is mandatory" {

            ($json.parameters.automationAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "description parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "description parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "startTime Validation" {

        It "Has startTime parameter" {

            $json.parameters.startTime | should not be $null
        }

        It "startTime parameter is of type string" {

            $json.parameters.startTime.type | should be "string"
        }

        It "startTime parameter default value is [utcNow()]" {

            $json.parameters.startTime.defaultValue | should be "[utcNow()]"
        }
    }

    Context "expiryTime Validation" {

        It "Has expiryTime parameter" {

            $json.parameters.expiryTime | should not be $null
        }

        It "expiryTime parameter is of type string" {

            $json.parameters.expiryTime.type | should be "string"
        }

        It "expiryTime parameter default value is 9999-12-31T23:59:00+00:00" {

            $json.parameters.expiryTime.defaultValue | should be "9999-12-31T23:59:00+00:00"
        }
    }

    Context "interval Validation" {

        It "Has interval parameter" {

            $json.parameters.interval | should not be $null
        }

        It "interval parameter is of type int" {

            $json.parameters.interval.type | should be "int"
        }

        It "interval parameter default value is 1" {

            $json.parameters.interval.defaultValue | should be 1
        }
    }

    Context "frequency Validation" {

        It "Has frequency parameter" {

            $json.parameters.frequency | should not be $null
        }

        It "frequency parameter is of type string" {

            $json.parameters.frequency.type | should be "string"
        }

        It "frequency parameter is mandatory" {

            ($json.parameters.frequency.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "frequency parameter allowed values are OneTime, Minute, Hour, Day, Week, Month" {

            (Compare-Object -ReferenceObject $json.parameters.frequency.allowedValues -DifferenceObject @("OneTime", "Minute", "Hour", "Day", "Week", "Month")).Length | should be 0
        }
    }

    Context "timeZone Validation" {

        It "Has timeZone parameter" {

            $json.parameters.timeZone | should not be $null
        }

        It "timeZone parameter is of type string" {

            $json.parameters.timeZone.type | should be "string"
        }

        It "timeZone parameter default value is Europe/London" {

            $json.parameters.timeZone.defaultValue | should be "Europe/London"
        }
    }

    Context "advancedSchedule Validation" {

        It "Has advancedSchedule parameter" {

            $json.parameters.advancedSchedule | should not be $null
        }

        It "advancedSchedule parameter is of type object" {

            $json.parameters.advancedSchedule.type | should be "object"
        }

        It "advancedSchedule parameter default value is an empty object" {

            $json.parameters.advancedSchedule.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }
}

Describe "Automation Account Schedule Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/schedules" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/schedules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }
}

Describe "Automation Account Schedule Output Validation" {

    Context "Automation Account Schedule Reference Validation" {

        It "type value is object" {

            $json.outputs.schedule.type | should be "object"
        }

        It "Uses full reference for Automation Account Schedule" {

            $json.outputs.schedule.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/jobs', parameters('automationAccountName'), parameters('scheduleName')), '2015-10-31', 'Full')]"
        }
    }
}