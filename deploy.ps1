New-AzResourceGroupDeployment -Name (New-Guid) -ResourceGroupName "rg1" -TemplateParameterFile ".\temptemplates\virtualnetwork.parameters.1.json" -TemplateFile ".\module\templates\Microsoft.Network\virtualNetworks\virtualNetwork.json" -Verbose



