aws_region  = "ap-southeast-2"         # Sydney
default_AMI = "ami-07fbdcfe29326c4fb"  # Ubuntu 20.04 LTS
hostname = "sinatra"
ssh_key_name = "deploy-sinatra"        # PUT YOUR KEYNAME HERE
root_volume_size = "12"
default_instance_type = "t2.micro" # t3.nano, t3.micro, t3a.nano, t3a.micro
ansible_ssh_user = "ubuntu"        # used in tf -> ansible handoff


