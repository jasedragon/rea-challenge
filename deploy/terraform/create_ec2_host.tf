#####################################################
###############     TERRAFORM     ###################
###############  Create EC2 Host  ###################
#####################################################

# Note: AWS Region is set by the aws cli configuration
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

