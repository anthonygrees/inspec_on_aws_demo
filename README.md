# InSpec On AWS Demo

### About
InSpec is an open-source testing framework by Chef that enables you to specify compliance, security, and other policy requirements.

InSpec can scan your systems to ensure their configuration and the software that's installed meet your compliance and security requirements. InSpec can also test your IAM roles, security groups, and other AWS resources.

This code repo shows the implementation of an InSpec profile running against an AWS environment that is created by Terraform and testing it.

### Prerequisites - Setting up AWS credentials for InSpec
Chef InSpec uses the standard AWS authentication mechanisms. Typically, you will create an IAM user specifically for auditing activities.

1. Create an IAM user in the AWS console, with your choice of username. Check the box marked “Programmatic Access.”
2. On the Permissions screen, choose Direct Attach. Select the AWS-managed IAM Profile named “ReadOnlyAccess.” If you wish to restrict the user further, you may do so; see individual Chef InSpec resources to identify which permissions are required.
3. After generating the key, record the Access Key ID and Secret Key.
More details are [here](https://github.com/inspec/inspec-aws#prerequisites)

Set up your AWS Credentials [InSpec-AWS](https://www.inspec.io/docs/reference/platforms/)

### Video Demo
Don't have time to get your fingers dirty with code???? Well, here is a video showing the code in action.

[![Alt text](https://img.youtube.com/vi/aktcFsH1gro/0.jpg)](https://youtu.be/aktcFsH1gro)

### Get Started
First you need the code !
```bash
git clone https://github.com/anthonygrees/inspec_on_aws_demo

cd inspec_on_aws_demo
```

### Create an AWS environment to test againsts
Execute the terraform. First run the initialise to ensure the plugins you need are installed:

```bash
terraform init
```
Before you run Terraform to create your infrastructure, it's a good idea to see what resources it would create. It also helps you verify that Terraform can connect to your AWS account.

```bash
terraform plan
```

and then apply to create the infrastructure.

```bash
terraform apply -auto-approve
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
inspec exec inspec-aws-security -t aws://us-west-2/
```

Your output on the command line will look like this:
![InSpecOutput](/images/inspec_output.png)

### How to send your InSpec output to Chef Automate
You will need to add a Chef Automate API `token` to the file `inspec-aws-security/automate.json` in order to send your output.

```bash
inspec exec inspec-aws-security -t aws://us-west-2/ --json-config inspec-aws-security/automate.json 
```

![AutomateOutput](/images/automate_output.png)
