output "vm_ip" {
  description = "IP-адрес созданной ВМ"
  value       = proxmox_virtual_environment_vm.rocky_vm[*].ipv4_addresses
}

output "vm_id" {
  description = "ID созданной ВМ"
  value       = proxmox_virtual_environment_vm.rocky_vm[*].vm_id
}
