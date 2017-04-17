variable "name" {}

variable "user_data" {
  default = "#!/bin/sh
      touch /dev/null"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "security_groups" {
  default = []
}

variable "subnet_id" {}

variable "instance_count" {
  default = 1
}

variable "keypair_name" {
  default = "rancher_keypair"
}
