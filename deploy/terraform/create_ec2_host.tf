#####################################################
###############  Create EC2 Host  ###################
#####################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15.0"
    }
  }
}

provider "aws" {
    profile = "default"
    region  = "ap-southeast-2" 
}

variable "aws_region"  {}
variable "hostname"    {}
variable "default_AMI" {}
variable "root_volume_size" {}
variable "default_instance_type" {}
variable "ssh_key_name" {}


# `terraform plan` will prompt for ssh key_name 
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


# call Ansible for OS setup and App install

output "Public_IP" {
  value = aws_instance.ec2machine.public_ip
}



