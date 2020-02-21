# copyright: 2018, The Authors
#

content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

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

title "AWS InSpec Tests"

control "AWS Instance ID" do                        # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title "Check Instance by ID"             # A human-readable title
  desc "An optional description..."

  describe aws_ec2_instance(webserver_id) do                  # The actual test
    it { should be_running }
    its('image_id') { should eq image_id } 
    its('instance_type') { should eq 't2.micro' }
    its('public_ip_address') { should eq webserver_public_ip }
    its('vpc_id') { should eq vpc_id }
    its('subnet_id') { should eq subnet_public }
    its('security_group_ids') { should include security_group_ssh_id }
    its('security_group_ids') { should include security_group_web_id }
  end
end


control "AWS Network" do                        # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title "Check Network by ID"             # A human-readable title
  desc "An optional description..."

  describe aws_vpc( vpc_id ) do
    its('state') { should eq 'available' }
    its('cidr_block') { should eq '10.0.0.0/16' }
  end

  describe aws_subnet( subnet_public ) do
    it { should exist }
    its('vpc_id') { should eq vpc_id }
    its('cidr_block') { should cmp '10.0.1.0/24' }
    its('availability_zone') { should eq 'us-west-2a' }
  end
  
  describe aws_subnet(subnet_public) do
    it { should exist }
    its('vpc_id') { should eq vpc_id }
    its('cidr_block') { should cmp '10.0.1.0/24' }
    its('availability_zone') { should eq 'us-west-2a' }
  end

  describe aws_security_group(security_group_web_id) do
    it { should exist }
  end
  
  describe aws_security_group(security_group_ssh_id) do
    it { should exist }
  end
  
  describe aws_security_group(security_group_mysql_id) do
    it { should exist }
  end
end

