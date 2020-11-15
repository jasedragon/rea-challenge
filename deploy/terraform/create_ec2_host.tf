#######################################################
# This script configures the EC2 machine, then hands 
# control to Ansible for configuration of said machine.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0.0"
    }
  }
}

provider "aws" {
    profile = "default"
    region  = "ap-southeast-2" 
}

# these are populated with values in terraform.tfvars
variable "aws_region"  {}
variable "hostname"    {}
variable "default_AMI" {}
variable "root_volume_size" {}
variable "default_instance_type" {}
variable "ssh_key_name" {}
variable "ansible_ssh_user" {}


# Create the EC2 machine
resource "aws_instance" "ec2machine" {
  ami            = var.default_AMI
  instance_type  = var.default_instance_type
  key_name       = var.ssh_key_name
  
  associate_public_ip_address = true

  # Set volume size for root filesystem 
  # encryption set to "true" by default 
  root_block_device {
    volume_size = var.root_volume_size
    encrypted   = true
  }

  # Set a tag for hostname
  tags = {
    Hostname  = var.hostname
  }
}


# Call Ansible for OS setup and App install
resource "null_resource" "run-provisioner" {
  provisioner "local-exec" {
    command = "sleep 10; ansible-playbook -u '${var.ansible_ssh_user}' --private-key $KEY --extra-vars='ec2_ip=${aws_instance.ec2machine.public_ip}' -i '${aws_instance.ec2machine.public_ip},' ../ansible/master.yml"

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      KEY = "~/.ssh/${var.ssh_key_name}.pem"
    }
  }
}

output "Public_IP" {
  value = aws_instance.ec2machine.public_ip
}



