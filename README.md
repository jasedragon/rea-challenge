Deploy the "Sinatra" app to AWS Cloud
=====================================


Terraform/Ansible 'hole'. When using the null resource method, terraform is unaware of changes to the ansible configuration. In order to trigger terraform to re-run ansible after changes, the null resource needs to be marked as tainted with `terraform taint null_resource.run-provisioner` Obviously not ideal.

- Provide documentation:
 
  - Explanation of assumptions and design choices.

Instructions for the reviewer which explain how your code should be executed
============


Requirements for running. (AWS account? Base images? Other tooling pre-installed?)
============

  - Tools:
      terraform, ansible
      Install the required tools 

These instructions assume the developer is using a Linux OS. 
Windows/OSX users are encouraged to utilise a suitable docker or vm image.

A successful deploy requires local installation of the following tools
- [AWS cli version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)
- [Terraform version >=0.13.0](https://www.terraform.io/downloads.html)
- [Ansible version >=2.9.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  Note: If using an ubuntu based distro, the latest PPA is for 19.10 and didn't work with my 20.04 distro. Ansible was successfully installed with `$ sudo pip3 install ansible`






      aws cli/credentials, 
      vpc
      iam role
      subnets - using default
      security groups
      DNS - setup a CNAME in your dns provider to point to AWS fqdn.

  - AWS account:

  - SSH Keypair: 
      In order to configure the OS and deploy the Sinatra application, an ssh keypair is required. Instructions for generating one can be found [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#new-console) Ensure you download the private key in pem format and take note of the AWS "Name" for the keypair and set that in the [vars file](deploy/terraform/terraform.tfvars)

New Heading
===========
The application will be installed on an AWS EC2 machine. The AWS account will have sufficient permissions to stop/start and create/destroy EC2 instances, as well as associating the EC2 instances with a pre-defined AWS security group. 

In order to control costs, instance types will be limited by IAM policy. (WIP)

As AWS EC2 images (AMIs) are region specific, changing the region will require replacing the AMI with the correct value for the new region in the code.


 
and that an appropriate VPC exists in the AWS region of choice. e 

version pinning - idempotency....

No requirement for interactive login was mentioned in the spec, accordingly the ssh service will be disabled and firewalled once the OS and application are configured. This has significant security benefits in terms of preventing hostile login attempts, however it also means the OS should be considered immutable i.e. non-upgradeable, and security updates can only be acheived by destroying the EC2 instance and creating a new one. This process could in the future be made seamless by implementing blue/green deploys in conjuction with AWS loadbalancer or EC2 based nginx instance. 

DNS options.

The amazon cloudwatch service requires port BLAH to be open and the WASM service to be running


Deploy the application to AWS
=============================
```shell 
$ git clone https://github.com/jasedragon/rea-challenge.git
$ cd deploy/terraform
$ terraform init # only once
$ terraform plan
$ terraform apply
```
CONFIRM LOCAL STORAGE RECORDS CREDENTIALS, and if so provide appropriate warning. Add confidential files to gitignore.

Script 
inputs - if aws cli is unconfigured, or you wish to use alternative credentials then supply the following environment variables, or leave them unconfigured and terraform will prompt for them. 
```shell 
$ export AWS_ACCESS_KEY_ID=AKIAIOUQNJUMMEXAMPLE
$ export AWS_SECRET_ACCESS_KEY=3rUIXtGv42kVb/XAAFCE1/BzoDmm5FL5xEXAMPLEKEY
$ export AWS_DEFAULT_REGION=ap-southeast-2
```

Reminder: NEVER store credentials in your code repo.

outputs - fqdn, ip address. Register output vars...



assumptions/design choices:
using terraform/ansible (widely applicable & agent-less tools) rather than cloudformation (AWS specific)
terraform backend - local, single user versus remote (S3/dynamodb)

The spec calls for an OS, so that is what is implemented here. A case could be made that building the application as an [AWS Lambda function on the ruby runtime](https://docs.aws.amazon.com/lambda/latest/dg/lambda-ruby.html) may provide security, mantainability and cost advantages.

ec2 versus docker 

ec2 std OS rather than custom image
internal firewall


existing vpc - simplify the problem
load balancer?

idempotency - blow away and rebuild versus atomic build steps
also allows for enhanced security but disabling all access (i.e. ssh) except on port 80
but what about cloudwatch? do we keep the aws client running?


Provision a new application server and deploy the application in this Git repository
------------------------------------------------------------------------------------
- Write configuration-as-code recipes (using your preferred orchestration software) to:
  - Create the server (can be local VM or AWS based)
  - Configure an OS image (your choice) appropriately.
  - Deploy the provided application.
  - Make the application available on port 80.
  - Ensure that the server is locked down and secure.


Expected output
---------------
- Scripts and/or configuration that we can use to deploy the application.
- Documentation.

Submission format
-----------------
Preferred option is a link to public git repository with your solution. 

To get the provided application working locally
===============================================

    git clone git@github.com:rea-cruitment/simple-sinatra-app.git
    shell $ bundle install
    shell $ bundle exec rackup


How we review the submission
============================
We rate the solution and documentation against all the following categories:

- Simplicity
- Code / documentation layout
- Ease of deployment
- Idempotency - blow whole server away on change. Not the best example but see how we go for time.
- Security - SGs & local iptables?
- Anti-fragility - version pinning?

The documentation is as important as the scripts. We are looking to understand why you chose a certain solution and what trade offs it has.

Documenting any known short comings of a solution and the reasons why will be seen as more positive than unmentioned issues. 



