Leelamanoj_Assignment_1
Root Terraform files
	main.tf
	variables.tf
	outputs.tf

README.md with clear execution & verification steps.

	VPC Module
		Create a VPC with a customizable CIDR (e.g., 10.0.0.0/16 via variable).
		Define two public subnets and two private subnets, each pair spread across two AZs (e.g., ap-south-1a, ap-south-1b).
	
	Created the resource using the "aws_vpc" resource identifier.
	Verify: Verify the new VPC created for the region provided where the default vpc value will be No.
	
	Security Groups Module
		Custom SG (sg_public_ec2):
			Inbound rules:
				SSH (TCP/22) from 0.0.0.0/0
				HTTP (TCP/80) from 0.0.0.0/0
			Outbound: allow all.

		Default SG: use the VPC’s default security group (no extra rules).
	
	Created the security group resource using "aws_security_group"
	Verify: The default security group will be created when the VPC created.
	
	RDS Module
		Launch an RDS MySQL instance:
			Engine version: latest MySQL LTS.
			Instance class: db.t3.micro.
			Storage: 20 GB.
			Subnet group referencing your private subnets.
			Security group: attach only the VPC’s default security group.
			No public accessibility.
	
	MySQL db created using aws_db_instance
	Verify: The subnet group with the private subnets. And as well the db will be created. Try to connect to the db using the ec2 launched.
	
	
	EC2 Module
		Launch an EC2 Linux instance (e.g., Amazon Linux 2) in one of your public subnets.
		Attach two security groups:
			1.	The custom SG (sg_public_ec2).
			2.	The default SG of the VPC.
			Assign a public IP.
			Use a key pair variable for SSH access.
	
	Launched the instance using the aws_instance identifier and well assigned the default security groups.
	verify: The instance launched as per the details given and the mentioned security groups attached and as well connected to instance using the key pair created.
	
Issue: IGW and Route details missed in assignment.
