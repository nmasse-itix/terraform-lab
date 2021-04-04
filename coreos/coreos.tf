data "ignition_config" "startup" {
  users = [
    data.ignition_user.core.rendered,
  ]

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index),
  ]

  count = var.coreos_machine_count
}

data "ignition_file" "hostname" {
  path       = "/etc/hostname"
  mode       = 420 # decimal 0644

  content {
    content = format(var.coreos_hostname_format, count.index + 1)
  }

  count = var.coreos_machine_count
}

data "ignition_user" "core" {
  name = "core"

  # Generate encrypted password with "openssl passwd -6"
  #password_hash = "$6$abc...xyz.0"

  ssh_authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPR1tt58X0+vbvsCR12gMAqr+g7vjt1Fx/qqz9EiboIs nicolas.masse@itix.fr", "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFW62WJXI1ZCMfNA4w0dMpL0fsldhbEfULNGIUB0nQui nmasse@redhat.com"]
}

resource "libvirt_volume" "coreos_disk" {
  name             = "${format(var.coreos_hostname_format, count.index + 1)}.${var.volume_format}"
  count            = var.coreos_machine_count
  format           = var.volume_format
  pool             = var.pool_name
  base_volume_name = "${var.coreos_image}.${var.volume_format}"
}

resource "libvirt_ignition" "ignition" {
  name    = "${format(var.coreos_hostname_format, count.index + 1)}-ignition"
  pool    = var.pool_name
  count   = var.coreos_machine_count
  content = element(data.ignition_config.startup.*.rendered, count.index)
}

resource "libvirt_domain" "coreos_machine" {
  count     = var.coreos_machine_count
  name      = format(var.coreos_hostname_format, count.index + 1)
  vcpu      = "1"
  memory    = "1024"
  coreos_ignition = element(libvirt_ignition.ignition.*.id, count.index)
  autostart = true

  disk {
    volume_id = element(libvirt_volume.coreos_disk.*.id, count.index)
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_id = libvirt_network.lab_net.id
    hostname = format(var.coreos_hostname_format, count.index + 1)

    # When creating the domain resource, wait until the network interface gets
    # a DHCP lease from libvirt, so that the computed IP addresses will be
    # available when the domain is up and the plan applied.
    wait_for_lease = true
  }
}

locals {
  coreos_machines = { for i in libvirt_domain.coreos_machine : i.name => i.network_interface.0.addresses[0] }
}
