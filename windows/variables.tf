
variable "windows_machine_count" {
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

variable "windows_hostname_format" {
  type    = string
  default = "win-%02d"
}

variable "windows_image" {
  type    = string
  default = "windows-10"
}

variable "network_name" {
  type    = string
  default = "lab"
}

variable "network_domain" {
  type    = string
  default = "sample.lab"
}

variable "network_ip_range" {
  type    = string
  default = "10.10.0.0/24"
}
