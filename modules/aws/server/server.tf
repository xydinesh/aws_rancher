data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "rancher_host" {
  count                       = "${var.instance_count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_groups}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true
  key_name                    = "${var.keypair_name}"
  user_data                   = "${var.user_data}"

  lifecycle {
    ignore_changes = ["user_data"]
  }

  tags {
    Name = "${var.name}-${count.index + 1}"
  }
}
