# InSpec On AWS Demo

### About
This demo shows the implementation of an InSpec profile running against an AWS environment and testing it.

### Prerequisites
Set up your AWS Credentials [InSpec-AWS](https://github.com/inspec/inspec-aws#prerequisites)

### Video Demo
The following video shows the code in action.

[![Alt text](https://youtu.be/aktcFsH1gro)](https://youtu.be/aktcFsH1gro)

### Create an AWS environment to test againsts
Execute the terraform.
```bash
terraform init
```
```bash
terraform apply
```
Once successfully created, you will get an output like this:
![TerraformOutput](/images/terraform_output.png)

### Setup for the InSpec Run

Copy all the terraform output into a `json` file.
```bash
terraform output --json > inspec-aws-security/files/terraform.json
```

The InSpec code expects the following input variables from the file:
```bash
webserver_id = params['ec2_instance.webserver']['value']
image_id = params['image_id']['value']
vpc_id = params['vpc.id']['value']
security_group_ssh_id = params['security_group.ssh.id']['value']
security_group_web_id = params['security_group.web.id']['value']
security_group_mysql_id = params['security_group.mysql.id']['value']
webserver_ami = params['ec2_instance.webserver.ami']['value']
webserver_public_ip = params['ec2_instance.webserver.public_ip']['value']
subnet_private = params['subnet.private.id']['value']
subnet_public = params['subnet.public.id']['value']
```

### Execute InSpec against AWS

```bash
inspec exec inspec-aws-security -t aws://us-west-2/chef-sa --json-config automate.json
```

Your output on the command line will look like this:
![InSpecOutput](/images/inspec_output.png)

### Send you InSpec output to Chef Automate
You will need to add a Chef Automate API `token` to the file `inspec-aws-security/automate.json` in order to send your output.

```bash
inspec exec inspec-aws-security -t aws://us-west-2/chef-sa --json-config inspec-aws-security/automate.json 
```

![AutomateOutput](/images/automate_output.png)