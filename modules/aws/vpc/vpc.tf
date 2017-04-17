resource "aws_vpc" "rancher_vpc" {
  cidr_block = "172.16.0.0/22"

  tags {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "rancher_subnet" {
  cidr_block = "172.16.0.0/24"
  vpc_id     = "${aws_vpc.rancher_vpc.id}"

  tags {
    Name = "${var.name}-subnet"
  }
}

resource "aws_internet_gateway" "rancher_igw" {
  vpc_id = "${aws_vpc.rancher_vpc.id}"

  tags {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "rancher_routes" {
  vpc_id = "${aws_vpc.rancher_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.rancher_igw.id}"
  }

  tags {
    Name = "${var.name}-route-table"
  }
}

resource "aws_route_table_association" "rancher_route_assoc" {
  subnet_id      = "${aws_subnet.rancher_subnet.id}"
  route_table_id = "${aws_route_table.rancher_routes.id}"
}

resource "aws_security_group" "rancher_server_sec_group" {
  name        = "rancher_server_security_group"
  description = "creating a security group for Rancher server"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.rancher_vpc.id}"
}

resource "aws_security_group" "rancher_agent_sec_group" {
  name        = "rancher_agent_security_group"
  description = "creating a security group to add host for Rancher"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.rancher_vpc.id}"
}

resource "aws_security_group" "gocd_sec_group" {
  name        = "gocd_sec_group"
  description = "creating a security group for gocd"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8153
    to_port     = 8153
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.rancher_vpc.id}"
}
