variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "Proxmox API token"
}

variable "proxmox_endpoint" {
  type        = string
  default     = "https://10.100.2.12:8006/"
  description = "Proxmox API endpoint"
}
