terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.82.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
  backend "http" {
  }
}

# --- Провайдер Vault ---
# provider "vault" {
#   # Адрес Vault передается через переменную окружения VAULT_ADDR
#   # или указывается здесь явно
#   # address = "https://vault.example.com:8200"
# }

# --- Чтение секретов из Vault ---
data "vault_kv_secret_v2" "proxmox_api" {
  mount = "proxmox" # Путь монтирования KV
  name  = "api"     # Путь к секрету
}

# --- Провайдер Proxmox ---
provider "proxmox" {
  endpoint  = "https://${local.proxmox_api["api_host"]}/"
  api_token = "${local.proxmox_api["api_user"]}!${local.proxmox_api["api_token_id"]}=${local.proxmox_api["api_token_proxmox"]}"
  insecure  = true
}
