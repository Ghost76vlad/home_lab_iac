output "vm_ip" {
  description = "IP-адреса ВМ без loopback"
  value = {
    for k, vm in proxmox_virtual_environment_vm.vms :
    k => [
      for ip in flatten(vm.ipv4_addresses) : ip
      if ip != "127.0.0.1"
    ][0]
  }
}

output "vm_id" {
  description = "ID всех созданных ВМ"
  value = {
    for k, vm in proxmox_virtual_environment_vm.vms :
    k => vm.vm_id
  }
}
