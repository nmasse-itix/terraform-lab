variable "vsphere_machine_count" {
  type    = number
  default = 1
}

variable "pool_name" {
  type    = string
  default = "default"
}

variable "volume_format" {
  type    = string
  default = "qcow2"
}

variable "os_volume_size" {
  type    = number
  default = 16 * 1024 * 1024 * 1024
}

variable "kvm_machine" {
  type    = string
  default = "pc-q35-rhel8.2.0"
}

variable "vmfs_volume_size" {
  type    = number
  default = 200 * 1024 * 1024 * 1024
}

variable "vcpu_count" {
  type    = number
  default = 4
}

variable "memory_size" {
  type    = number
  default = 8192
}


variable "vsphere_hostname_format" {
  type    = string
  default = "esx-%02d"
}

variable "vsphere_iso" {
  type    = string
  default = "/var/lib/libvirt/images/vsphere-custom.iso"
}

variable "network_name" {
  type    = string
  default = "lab"
}

variable "network_domain" {
  type    = string
  default = "sample.lab"
}

variable "bridge_network" {
  type    = string
  default = "bridge"
}

variable "network_ip_range" {
  type    = string
  default = "10.10.0.0/24"
}
