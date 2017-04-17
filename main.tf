provider "aws" {
  region = "${var.region}"
}

module "rancher_vpc" {
  source = "./modules/aws/vpc"
  name   = "rancher"
}

module "rancher_server" {
  source          = "./modules/aws/server"
  name            = "rancher-server"
  security_groups = ["${module.rancher_vpc.rancher_server_security_group}"]
  subnet_id       = "${module.rancher_vpc.rancher_subnet_id}"
  keypair_name    = "${var.keypair_name}"
  instance_type   = "${var.instance_type}"

  user_data = "#!/bin/sh
            apt-get update
            apt-get install -y docker.io
            sudo docker run -d --restart=unless-stopped -p 8080:8080 rancher/server"
}

module "rancher_agent" {
  source          = "./modules/aws/server"
  instance_count  = "${var.agent_count}"
  name            = "rancher-agent"
  security_groups = ["${module.rancher_vpc.rancher_agent_security_group}", "${module.rancher_vpc.gocd_security_group}"]
  subnet_id       = "${module.rancher_vpc.rancher_subnet_id}"
  keypair_name    = "${var.keypair_name}"
  instance_type   = "${var.instance_type}"
}

data "template_file" "agent-userdata" {
  template = "${file("data/user-data.agent")}"

  vars {
    server_ip_address = "${element(split(",", module.rancher_server.public_ip), 0)}"
  }
}

resource "null_resource" "configure_rancher_hosts" {
  count = "${var.agent_count}"

  connection {
    type        = "ssh"
    agent       = false
    user        = "ubuntu"
    host        = "${element(split(",", module.rancher_agent.public_ip), count.index)}"
    private_key = "${file("${var.key_file}")}"
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.agent-userdata.rendered}"]
  }
}
