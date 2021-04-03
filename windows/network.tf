resource "libvirt_network" "lab_net" {
  name      = var.network_name
  mode      = "nat"
  domain    = var.network_domain
  addresses = [var.network_ip_range]
  autostart = true
  dns {
    enabled = true
  }
  dhcp {
    enabled = true
  }
}
