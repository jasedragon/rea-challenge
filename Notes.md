service management - passenger/puma
more mature environment with secure log server, green/blue deploys behind load balancer, managed by auto-scaling groups - would allow immutable server.


aws cli/credentials, 
vpc
iam role
subnets - using default
security groups
DNS - setup a CNAME in your dns provider to point to AWS fqdn.

and that an appropriate VPC exists in the AWS region of choice. e 

version pinning - idempotency....

remote logging

ec2 versus docker 

ec2 std OS rather than custom image
internal firewall

existing vpc - simplify the problem
load balancer?

idempotency - blow away and rebuild versus atomic build steps
also allows for enhanced security but disabling all access (i.e. ssh) except on port 80
but what about cloudwatch? do we keep the aws client running?

outputs - fqdn, ip address. Register output vars...


assumptions/design choices:
using terraform/ansible (widely applicable & agent-less tools) rather than cloudformation (AWS specific)
terraform backend - local, single user versus remote (S3/dynamodb)

The spec calls for an OS, so that is what is implemented here. A case could be made that building the application as an [AWS Lambda function on the ruby runtime](https://docs.aws.amazon.com/lambda/latest/dg/lambda-ruby.html) may provide security, mantainability and cost advantages.
ild versus atomic build steps
also allows for enhanced security but disabling all access (i.e. ssh) except on port 80
but what about cloudwatch? do we keep the aws client running?

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
- Security - 
- Anti-fragility - version pinning? or is this concerning e.g. self-restarting app (init/systemd)




