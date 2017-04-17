# Rancher cluster in AWS under 2 minutes

Go ahead and edit content of `terraform.tfvars` to match your cluster configuration and nodes.

```
region = "us-west-1"
instance_type = "t2.medium"
keypair_name = "rancher_keypair"
key_file = "~/.ssh/rancher_keypair.pem"
agent_count = "1"
```

and then run

```
$ terraform plan

$ terraform apply
```

When the deployment complete, you can access rancher cluster on http://server_ip:8080. You can see agent hosts under `Infrastructure -> Host`.

In order to teardown the cluster

```
$ terraform destroy
```


