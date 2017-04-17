output "public_ip" {
  value = "${join(",", aws_instance.rancher_host.*.public_ip)}"
}

output "deployment_count" {
  value = "${var.instance_count}"
}
