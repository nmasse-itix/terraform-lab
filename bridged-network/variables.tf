
variable "centos_machine_count" {
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

variable "centos_hostname_format" {
  type    = string
  default = "centos-%02d"
}

variable "centos_image" {
  type    = string
  default = "centos-stream-8"
}

variable "network_name" {
  type    = string
  default = "lab"
}

variable "centos_mac_format" {
  type    = string
  default = "02:01:07:00:07:%02x"
}

variable "centos_mac_start" {
  type    = number
  default = 10
}
