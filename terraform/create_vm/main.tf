resource "proxmox_virtual_environment_vm" "rocky_vm" {
  name      = var.vm_name
  node_name = local.proxmox_api["node"]
  # vm_id     = var.vm_id
  count = "3"

  clone {
    vm_id = var.template_id
    full  = true
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
    numa  = true
  }

  memory {
    dedicated = var.memory_mb
  }

  # Явно указываем диск, чтобы провайдер не переопределял datastore
  disk {
    datastore_id = "data-4T" # как в шаблоне
    interface    = "scsi0"
    size         = var.disk_size_sys
    backup       = false
    cache        = "writeback"
    iothread     = true
    # file_format = "raw"  # опционально
  }
  disk {
    datastore_id = "data-4T" # как в шаблоне
    interface    = "scsi1"
    size         = var.disk_size_data
    backup       = false
    cache        = "writeback"
    iothread     = true
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    datastore_id = "data-4T"
    user_account {
      username = var.ansible_user
      password = local.proxmox_api["ansible_passwd"]
      keys     = [local.proxmox_api["ssh_key_ansible"]]
    }
  }

  agent {
    enabled = true
  }

  started = true
}