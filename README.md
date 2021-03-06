# Deploy Sinatra Application to AWS Cloud

Note: This is a demo application and not intended for production use.

## TLDR

```shell 
$ git clone https://github.com/jasedragon/rea-challenge.git
$ cd rea-challenge/
$ cd deploy/terraform
$ terraform init # only once
$ terraform apply
```


## Assumptions, Design Choices & Shortcomings

### Hosting Environment
* The application will be installed on an AWS EC2 machine. A docker container would also be suitable if that was the preference. 
* There are no specific local or international regulatory requirements (PCI-DSS, HIPAA, GDPR etc..) that would impose restrictions on hosting environment.
* Users are predominantly local i.e located in Australia, as such the code is configured to deploy to the AWS datacenter in Sydney.
* Note: AWS EC2 images (AMIs) are region specific, changing the region will require replacing the AMI with the correct value for the new region in the code.

### AWS Account 
* An appropriate VPC exists in the AWS region of choice. This VPC should be separate from others hosting unrelated services. Automating the creation of Security Groups, along with the relevant VPC, is outside the scope of this project. 
* The AWS account will have sufficient permissions to stop/start and create/destroy EC2 instances in the chose AWS Region. Example [IAM policy here](deploy/policy/Restrict_Region.json).
* In the case that the AWS account is configured for both gui and cli access, [limited access to Cloudwatch](deploy/policy/Limited_Cloudwatch.json) can be configured in order for the AWS gui to display basic EC2 monitoring information.
* In order to control costs, instance types will be [limited by IAM policy](deploy/policy/Limit_EC2_instance_types.json). (WIP)
* To configure the OS and deploy the Sinatra application, an ssh keypair is required. Instructions for generating one can be found [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#new-console) Ensure you download the private key in pem format and take note of the AWS "Name" for the keypair and set that in the [vars file](deploy/terraform/terraform.tfvars)


### Development Environment
These instructions assume the developer is using a Linux OS. 
Windows/OSX users are encouraged to utilise a suitable docker or vm image.

A successful deploy requires local installation of the following tools
* [AWS cli version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)
* [Terraform version >=0.13.0](https://www.terraform.io/downloads.html)
* [Ansible version >=2.9.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  Note: If using an ubuntu based distro, the latest PPA is for 19.10 and didn't work with my 20.04 distro. Ansible was successfully installed with `$ sudo pip3 install ansible`


The choice to use Terraform and Ansible rather than AWS Cloudformation is due to the former being cloud agnostic rather than AWS specific. This provides flexibility in choice of cloud provider & leads to greater code reusability. There are other options for IAC and server configuration, however many of these require substantial supporting infrastructure or installation of agents on destination servers. In contrast Terrafom needs only AWS credentials and Ansible requires only ssh access and that python3 be installed on destination server.


A shortcoming of this tooling choice is the Terraform/Ansible handoff. In this codebase, once Terraform has created the base EC2 machine it then calls Ansible to complete the configuration of it. This can be seen near the end of [create_ec2_host.tf](deploy/terraform/create_ec2_host.tf) 

When using the null resource method, Terraform is unaware of changes to the Ansible configuration. In order to trigger Terraform to re-run Ansible after changes to [master.yml](deploy/ansible/master.yml), the null resource needs to be marked as tainted with `terraform taint null_resource.run-provisioner`. Another unresolved problem is the need to insert a delay before calling Ansible.  Obviously not ideal.  

#### Initial Deploy
```shell 
$ git clone https://github.com/jasedragon/rea-challenge.git
$ cd rea-challenge/
$ cd deploy/terraform
$ terraform init # only once
$ terraform apply
```

#### Additional Deploys
```shell 
$ cd rea-challenge/
$ cd deploy/terraform
$ terraform taint null_resource.run-provisioner
$ terraform apply
```

Another concern with Terraform is the storage of credentials in the the state files - it is **CRITICALLY IMPORTANT** that these state files are not submitted to the code repository, so [gitignore](./.gitignore) entries exist for these files. 

Note also that here Terraform is initialised with the default local backend which is not suitable for multi-developer access. 
It is a faily simple matter to enable remote backend on encrypted S3 storage, with dynamodb locking. This allows for safe multi-user development.


### Operational Environment
There are many valid reasons for choosing one OS over another. Amazon Linux or RedHat would be perfectly fine, however Ubuntu 20.04 LTS was selected based on this developers' most recent experience. Although the spec calls for an OS, a case could be made that building the application as an [AWS Lambda function on the ruby runtime](https://docs.aws.amazon.com/lambda/latest/dg/lambda-ruby.html) may provide security, mantainability or cost advantages. 

The Sinatra application has been configured to utilise the multi-threaded puma server, which provides performance benefits, as well as the nginx proxy. Nginx listens on port 80 for http traffic and passes it via unix socket to the puma server. This arrangement has the security advantage of running Sinatra unprivileged. Puma has been configured to run under systemd management, which provides automatic restart capability as well as syslog logging.

No SSL was specified. Unless there are particular reasons to NOT use SSL, it should be enabled even when no sensitive data (e.g. logins) are being sent over the network.  In addition to protecting privacy SSL also enhances data integrity by providing verification of server domain as well as mitigating man-in-the-middle attacks. 

As per the spec SSL has not been implemented, however it is easily supported in the nginx config once public DNS and certificate have been arranged (e.g. AWS, letsencrypt or traditional standalone SSL certificate)
 
No requirement for interactive login was mentioned in the spec however the ssh service currently remains available allowing for additional configuration via Ansible. SSH is configured by default to not allow root login, and logins by the 'ubuntu' user are by key only, no password access is allowed. The fail2ban service has also been installed in order to minimize network traffic associated with attempts to brute-force ssh.

The ssh service could be disabled and firewalled once the OS and application are configured, in that case the OS would be considered immutable i.e. non-upgradeable, and security updates could only be acheived by destroying the EC2 instance and creating a new one. 


Last item to note pertains to AWS Security Groups. As the code currently stands it is utilising the automatically generated default SG, which allows access to ssh (port 22) and http (port 80) only from the developers ip address. This is a secure default that allows for end-to-end testing prior to opening up for wider access. 

Enjoy your Sinatra Application!

