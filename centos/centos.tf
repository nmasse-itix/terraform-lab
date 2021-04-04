
resource "libvirt_cloudinit_disk" "centos_cloudinit" {
  name           = "centos-cloudinit.iso"
  user_data      = file("${path.module}/templates/cloud-init.cfg")
  network_config = file("${path.module}/templates/network-config.cfg")
  pool           = var.pool_name
}

resource "libvirt_volume" "centos_disk" {
  name             = "${format(var.centos_hostname_format, count.index + 1)}.${var.volume_format}"
  count            = var.centos_machine_count
  format           = var.volume_format
  pool             = var.pool_name
  base_volume_name = "${var.centos_image}.${var.volume_format}"
}

resource "libvirt_domain" "centos_machine" {
  count     = var.centos_machine_count
  name      = format(var.centos_hostname_format, count.index + 1)
  vcpu      = "1"
  memory    = "1024"
  cloudinit = libvirt_cloudinit_disk.centos_cloudinit.id
  autostart = true

  disk {
    volume_id = element(libvirt_volume.centos_disk.*.id, count.index)
  }

  # Makes the tty0 available via `virsh console`
  console {
    type        = "pty"
    target_port = "0"
  }

  network_interface {
    network_id = libvirt_network.lab_net.id
    hostname   = format(var.centos_hostname_format, count.index + 1)

    # When creating the domain resource, wait until the network interface gets
    # a DHCP lease from libvirt, so that the computed IP addresses will be
    # available when the domain is up and the plan applied.
    wait_for_lease = true
  }
}

locals {
  centos_machines = { for i in libvirt_domain.centos_machine : i.name => i.network_interface.0.addresses[0] }
}
