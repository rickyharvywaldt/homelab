terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.2-rc05"
        }
    }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token = var.vault_token
}

data "vault_generic_secret" "proxmox" {
  path = "secret/proxmox"
}

provider "proxmox" {
    pm_api_url          = data.vault_generic_secret.proxmox.data["pm_api_url"]
    pm_api_token_id     = "terraform-prov@pve!terraform"
    pm_api_token_secret = data.vault_generic_secret.proxmox.data["pm_api_token_secret"]
    pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "vm-instance" {
    name                = "vm-instance"
    target_node         = "pve"
    clone               = "ubuntu-2204-template"
    full_clone          = true
    cores               = 2
    memory              = 2048

    disk {
        slot            = "scsi0"
        size            = "32G"
        type            = "cloudinit"
        storage         = "local-lvm"
        discard         = true
    }

    network {
        id        = 0
        model     = "virtio"
        bridge    = "vmbr0"
        firewall  = false
        link_down = false
    }

}
