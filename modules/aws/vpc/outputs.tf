output "rancher_subnet_id" {
  value = "${aws_subnet.rancher_subnet.id}"
}

output "rancher_server_security_group" {
  value = "${aws_security_group.rancher_server_sec_group.id}"
}

output "rancher_agent_security_group" {
  value = "${aws_security_group.rancher_agent_sec_group.id}"
}

output "gocd_security_group" {
  value = "${aws_security_group.gocd_sec_group.id}"
}
