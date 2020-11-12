REA Systems Engineer practical task
===================================

- Provide documentation:
  - Instructions for the reviewer which explain how your code should be executed
  - Requirements for running. (AWS account? Base images? Other tooling pre-installed?)
  - Explanation of assumptions and design choices.


Deploy the application to AWS
=============================
    shell $ git clone https://github.com/jasedragon/rea-challenge.git
    shell $ cd deploy
    shell $ terraform init # only once
    shell $ terraform plan
    shell $ terraform apply

Script 
inputs - if aws cli is unconfigured, or you wish to use alternative credentials then supply the following environment variables, or wait for terraform to prompt for them. 
shell $ export AWS_ACCESS_KEY_ID=AKIAIOUQNJUMMEXAMPLE
shell $ export AWS_SECRET_ACCESS_KEY=3rUIXtGv42kVb/XAAFCE1/BzoDmm5FL5xEXAMPLEKEY
shell $ export AWS_DEFAULT_REGION=ap-southeast-2

Reminder: NEVER store credentials in your code repo.

outputs - fqdn, ip address. 

pre-reqs
aws cli/credentials, 
terraform, ansible

vpc
iam role
security groups
DNS - setup a CNAME in your dns provider to point to AWS fqdn.

assumptions/design choices:
using terraform/ansible (widely applicable & agent-less tools) rather than cloudformation (AWS specific)
terraform backend - local, single user versus remote (S3/dynamodb)

The spec calls for an OS, had this not been the case then building the application as an [AWS Lambda function](https://docs.aws.amazon.com/lambda/latest/dg/lambda-ruby.html) on the ruby runtime may have provided security, mantainability and cost advantages.

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

Install the required tools 
==========================
These instructions assume the developer is using a linux OS. 
Windows/OSX users are encouraged to utilise a suitable docker or vm image.

A successful deploy requires local installation of the following tools
- [AWS cli version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html)
- [Terraform version >=0.13.0](https://www.terraform.io/downloads.html)
- [Ansible version >=2.9.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  Note: If using an ubuntu based distro, the latest PPA is for 19.10 and didn't work with my 20.04 distro. Ansible was successfully installed with 
  shell $ sudo pip3 install ansible





