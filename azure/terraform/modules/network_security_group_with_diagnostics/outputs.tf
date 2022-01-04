output "network_security_group_id" {
  value       = azurerm_network_security_group.network.id
  description = "Resource ID of the Network Security Group"
}