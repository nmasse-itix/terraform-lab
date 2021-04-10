resource "libvirt_volume" "vsphere_os_disk" {
  name   = "${format(var.vsphere_hostname_format, count.index + 1)}-os.${var.volume_format}"
  count  = var.vsphere_machine_count
  format = var.volume_format
  pool   = var.pool_name
  size   = var.os_volume_size
}

resource "libvirt_volume" "vsphere_vmfs_disk" {
  name   = "${format(var.vsphere_hostname_format, count.index + 1)}-vmfs.${var.volume_format}"
  count  = var.vsphere_machine_count
  format = var.volume_format
  pool   = var.pool_name
  size   = var.vmfs_volume_size
}

resource "libvirt_domain" "vsphere_machine" {
  count   = var.vsphere_machine_count
  name    = format(var.vsphere_hostname_format, count.index + 1)
  vcpu    = var.vcpu_count
  memory  = var.memory_size
  machine = var.kvm_machine

  boot_device {
    dev = ["hd", "cdrom"]
  }

  disk {
    volume_id = element(libvirt_volume.vsphere_os_disk.*.id, count.index)
  }

  disk {
    volume_id = element(libvirt_volume.vsphere_vmfs_disk.*.id, count.index)
  }

  cpu = {
    mode = "host-passthrough"
  }

  disk {
    file = var.vsphere_iso
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }

  video {
    type = "qxl"
  }

  network_interface {
    network_id     = libvirt_network.lab_net.id
    addresses      = [cidrhost(var.network_ip_range, count.index + 11)]
    hostname       = format(var.vsphere_hostname_format, count.index + 1)
    wait_for_lease = true
  }

  xml {
    xslt = file("patch.xslt")
  }
}

locals {
  vsphere_machines = { for i in libvirt_domain.vsphere_machine : i.name => i.network_interface.0.addresses[0] }
}
