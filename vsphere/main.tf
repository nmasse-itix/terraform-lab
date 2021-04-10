terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">=0.6.3"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
  }
}

output "machines" {
  value = local.vsphere_machines
}
