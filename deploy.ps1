New-AzResourceGroupDeployment -Name (New-Guid) -ResourceGroupName "rg1" -TemplateParameterFile ".\parameters\virtualnetwork.parameters.1.json" -TemplateFile ".\templates\Microsoft.Network\virtualNetworks\virtualNetwork.json" -Verbose



