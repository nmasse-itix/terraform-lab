resource "libvirt_volume" "win_disk" {
  name             = "${format(var.windows_hostname_format, count.index + 1)}.${var.volume_format}"
  count            = var.windows_machine_count
  format           = var.volume_format
  pool             = var.pool_name
  base_volume_name = "${var.windows_image}.${var.volume_format}"
}

resource "libvirt_domain" "win_machine" {
  count     = var.windows_machine_count
  name      = format(var.windows_hostname_format, count.index + 1)
  vcpu      = "2"
  memory    = "2048"

  cpu = {
    mode = "host-passthrough"
  }
  
  disk {
    volume_id = element(libvirt_volume.win_disk.*.id, count.index)
  }

  network_interface {
    network_id = libvirt_network.lab_net.id
    hostname = format(var.windows_hostname_format, count.index + 1)

    # When creating the domain resource, wait until the network interface gets
    # a DHCP lease from libvirt, so that the computed IP addresses will be
    # available when the domain is up and the plan applied.
    wait_for_lease = true
  }
}
