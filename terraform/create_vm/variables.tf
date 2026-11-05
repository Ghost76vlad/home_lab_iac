# --- Локальные значения (из Vault) ---
locals {
  # Секреты из Vault, помеченные как sensitive
  proxmox_api = sensitive(data.vault_kv_secret_v2.proxmox_api.data)
}

# --- Входные переменные ---
variable "vm_name" {
  description = "Имя создаваемой ВМ"
  type        = string
  default     = "test"
}

variable "vm_id" {
  description = "ID виртуальной машины в Proxmox"
  type        = number
  default     = 500
}

variable "template_id" {
  description = "ID шаблона для клонирования"
  type        = number
  default     = 912
}

variable "cpu_cores" {
  description = "Количество ядер CPU"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Объем RAM в МБ"
  type        = number
  default     = 2048
}

variable "disk_size_sys" {
  description = "Размер диска в ГБ"
  type        = number
  default     = 30
}

variable "disk_size_data" {
  description = "Размер диска в ГБ"
  type        = number
  default     = 50
}

# variable "network_bridge" {
#   description = "Сетевой мост Proxmox"
#   type        = string
#   default     = "vmbr0"
# }

variable "ansible_user" {
  description = "Имя пользователя для Cloud-Init"
  type        = string
  default     = "ansible"
}
