resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.vms

  name      = each.value.name
  node_name = local.proxmox_api["node"]
  # vm_id     = var.vm_id
  # count = "3"

  clone {
    vm_id = each.value.template_id
    full  = each.value.clone_full
  }
  cpu {
    cores = each.value.cpu_cores
    type  = each.value.cpu_type
    numa  = each.value.cpu_numa
  }
  memory {
    dedicated = each.value.memory_mb
  }

  # Явно указываем диск, чтобы провайдер не переопределял datastore
  disk {
    datastore_id = each.value.disk_storages
    interface    = each.value.disk_interface_sys
    size         = each.value.disk_size_sys
    backup       = each.value.disk_backup
    cache        = each.value.disk_cache
    iothread     = each.value.disk_iothread
    # file_format = "raw"  # опционально
  }
  disk {
    datastore_id = each.value.disk_storages
    interface    = each.value.disk_interface_data
    size         = each.value.disk_size_data
    backup       = each.value.disk_backup
    cache        = each.value.disk_cache
    iothread     = each.value.disk_iothread
  }

  network_device {
    bridge = each.value.network_bridge
    model  = each.value.network_model
  }

  initialization {
    datastore_id = each.value.disk_storages
    user_account {
      username = each.value.ansible_user
      password = local.proxmox_api["ansible_passwd"]
      keys     = [local.proxmox_api["ssh_key_ansible"]]
    }
  }

  agent {
    enabled = each.value.qemu_agent
    wait_for_ip {
      ipv4 = true
    }
  }

  started = each.value.vm_started
}

resource "local_file" "ansible_inventory_ini" {
  filename = "../../inventory.ini"
  content = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    vm_ips = {
      for k, vm in proxmox_virtual_environment_vm.vms :
      k => [
        for ip in flatten(vm.ipv4_addresses) : ip
        if ip != "127.0.0.1"
      ][0]
    }
  })
  file_permission = "0644"
}
