# **Spin up 2x RHEL EC2 Instances with Terraform**

This is an attempt to spin up 2x RHEL EC2 instances with Terraform for practice

## Prerequisites

Ensure following tools are installed on local machine

1. Terraform 
2. AWS CLI
3. Authentication key

## Setup

1. After completing the terraform code, proceed to provision the infrastructure

```sh
terraform init
```

```sh
terraform plan
```

```sh
terraform apply --auto-approve
```

2. Take note of the public IP addresses and use SSH with key path to connect to either of VMs.

```sh
ssh -i <path_to_private_key> ec2-user@<public_ip_address>
```