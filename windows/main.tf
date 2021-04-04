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
  value = local.windows_machines
}

resource "local_file" "ansible_inventory" {
  content         = templatefile("${path.module}/templates/inventory", { windows_machines = local.windows_machines, network_domain = var.network_domain })
  filename        = "ansible/inventory"
  file_permission = "0644"

  provisioner "local-exec" {
    working_dir = "${path.module}/ansible"
    command     = <<EOT
set -e
ansible-galaxy install -r requirements.yml
ansible-playbook -i inventory prepare.yaml -e tf_action=start
    EOT

  }

  provisioner "local-exec" {
    working_dir = "${path.module}/ansible"
    when        = destroy
    command     = <<EOT
set -e
ansible-playbook -i inventory prepare.yaml -e tf_action=stop
    EOT

  }
}
