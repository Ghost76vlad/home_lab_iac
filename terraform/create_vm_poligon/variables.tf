# --- Локальные значения (из Vault) ---
locals {
  # Секреты из Vault, помеченные как sensitive
  proxmox_api = sensitive(data.vault_kv_secret_v2.proxmox_api.data)
}

# --- Входные переменные ---

variable "vms" {
  description = "Параметры виртуальных машин"
  type = map(object({
    name                = string
    clone_full          = bool
    template_id         = number
    cpu_cores           = number
    cpu_type            = string
    cpu_numa            = bool
    memory_mb           = number
    disk_size_sys       = number
    disk_size_data      = number
    disk_storages       = string
    disk_interface_sys  = string
    disk_interface_data = string
    disk_backup         = bool
    disk_cache          = string
    disk_iothread       = bool
    network_bridge      = string
    network_model       = string
    ansible_user        = string
    qemu_agent          = bool
    vm_started          = bool
  }))
}
