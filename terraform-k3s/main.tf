# This is a basic Terraform configuration to clone a VM from a template using the bpg/proxmox provider.
# Fill in the variables below with your specific Proxmox environment details.
# This block tells Terraform to use the bpg/proxmox provider.
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      # It's a good practice to pin a specific version to prevent unexpected changes.
      version = ">=0.80.0" 
    }
  }
}

# Configure the Proxmox provider.
# You can use a dedicated API token for authentication, which is more secure than a username and password.
provider "proxmox" {
  # The endpoint is the URL of your Proxmox VE API, usually with port 8006.
  endpoint = var.proxmox_endpoint
  # The API token should be in the format "<token_id>=<token_secret>"
  # It is highly recommended to use environment variables or a separate tfvars file for sensitive data.
  api_token = var.proxmox_api_token
  # Set to true to bypass TLS certificate verification.
  insecure = true
}

# The proxmox_virtual_environment_vm resource is used to manage a VM.
resource "proxmox_virtual_environment_vm" "vm" {
  # A descriptive name for the new VM.
  name = "k3s-cp1"
  # The name of the Proxmox node where the VM will be created.
  node_name = "pve1"
  # A unique VM ID. Proxmox will assign one if not specified.
  vm_id = 200
  # This block is crucial for cloning from a template.
  clone {
    # The vm_id of the existing template you want to clone from.
    vm_id = 100
    # Set to true for a full clone, which creates an independent disk image.
    full = true
  }  
  # Set the number of CPU cores for the new VM.
  cpu {
    cores = 2
  }

  # Set the dedicated memory in MB for the new VM.
  memory {
    dedicated = 2048
  }

  # Configure the VM's disk.
  # This section can be used to override or add disks to the cloned VM.
  # The disk cloned from the template is automatically handled.
  # Example to create a new disk on a different datastore:
  # disk {
  #   datastore_id = "local-lvm"
  #   interface    = "scsi0"
  #   size         = 32
  # }

  # Configure networking for the VM. This example uses a bridged network device.
  network_device {
    bridge = "vmbr0"
  }
 agent {
    enabled = false   # disables waiting for guest agent
  }
  

  initialization {
    ip_config {
      ipv4 {
        # Set the IPv4 address to "dhcp" to use a dynamic IP address from the network.
        address = "dhcp"
      }
    }
  }
}


