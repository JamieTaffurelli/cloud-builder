$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Public Certificate Parameter Validation" {

    Context "certificateName Validation" {

        It "Has certificateName parameter" {

            $json.parameters.appName | should not be $null
        }

        It "certificateName parameter is of type string" {

            $json.parameters.certificateName.type | should be "string"
        }

        It "certificateName parameter is mandatory" {

            ($json.parameters.certificateName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "appName Validation" {

        It "Has appName parameter" {

            $json.parameters.appName | should not be $null
        }

        It "appName parameter is of type string" {

            $json.parameters.appName.type | should be "string"
        }

        It "appName parameter is mandatory" {

            ($json.parameters.appName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "blobString Validation" {

        It "Has blobString parameter" {

            $json.parameters.blobString | should not be $null
        }

        It "blobString parameter is of type securestring" {

            $json.parameters.blobString.type | should be "securestring"
        }

        It "blobString parameter is mandatory" {

            ($json.parameters.blobString.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }


    Context "publicCertificateLocation Validation" {

        It "Has publicCertificateLocation parameter" {

            $json.parameters.publicCertificateLocation | should not be $null
        }

        It "publicCertificateLocation parameter is of type string" {

            $json.parameters.publicCertificateLocation.type | should be "string"
        }

        It "publicCertificateLocation parameter default value is CurrentUserMy" {

            $json.parameters.publicCertificateLocation.defaultValue | should be "CurrentUserMy"
        }

        It "publicCertificateLocation parameter allowed values are 'CurrentUserMy', 'LocalMachineMy', 'Unknown'" {

            (Compare-Object -ReferenceObject $json.parameters.publicCertificateLocation.allowedValues -DifferenceObject @("CurrentUserMy", "LocalMachineMy", "Unknown")).Length | should be 0
        }
    }
}

Describe "Public Certificate Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/sites/publicCertificates" {

            $json.resources.type | should be "Microsoft.Web/sites/publicCertificates"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2016-03-01" {

            $json.resources.apiVersion | should be "2016-03-01"
        }
    }
}
Describe "Public Certificate Output Validation" {

    Context "Public Certificate Reference Validation" {

        It "type value is object" {

            $json.outputs.cert.type | should be "object"
        }

        It "Uses full reference for App Service" {

            $json.outputs.cert.value | should be "[reference(resourceId('Microsoft.Web/sites/publicCertificates', parameters('appName'), parameters('certificateName')), '2016-03-01', 'Full')]"
        }
    }
}