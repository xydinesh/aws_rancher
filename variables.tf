variable "region" {
  default = "us-east-1"
}

variable "agent_count" {
  default = 2
}

variable "key_file" {
  default = "~/.ssh/rancher_keypair.pem"
}

variable "keypair_name" {}

variable "instance_type" {}
