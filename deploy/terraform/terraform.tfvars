aws_region  = "ap-southeast-2"         # Sydney
default_AMI = "ami-07fbdcfe29326c4fb"  # Ubuntu 20.04 LTS
hostname = "sinatra"
ssh_key_name = "deploy-sinatra"        # PUT YOUR KEYNAME HERE
root_volume_size = "12"
default_instance_type = "t2.micro" # t3.nano, t3.micro, t3a.nano, t3a.micro


# variable "hostname" {
#   default = "sinatra"
# }

# variable "default_AMI" {
#   description = "OS Ubuntu 20.04 LTS"
#   default = "ami-07fbdcfe29326c4fb"
# }

# variable "root_volume_size" {
#   description = "EC2 root volume size in GB"
#   default = "12"
# }

# # Set instance size here, allowed values are
# # t3.nano, t3.micro, t3a.nano, t3a.micro
# variable "default_instance_type" {
#   description = "T3a nano"
#   default = "t3a.nano"
# }

