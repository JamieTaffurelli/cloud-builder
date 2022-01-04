output "virtual_machine_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "Resource ID of the Virtual Machine"
}

output "identity" {
  value       = azurerm_windows_virtual_machine.vm.identity
  description = "Identity of the Virtual Machine"
}

output "private_ip_address" {
  value       = azurerm_windows_virtual_machine.vm.private_ip_address
  description = "Private IP address of the Virtual Machine"
}

output "public_ip_address" {
  value       = azurerm_windows_virtual_machine.vm.identity
  description = "Public IP address of the Virtual Machine"
}
