terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#───────────────────────────────────────────────────────────────────────────────
# VARIABLES
#───────────────────────────────────────────────────────────────────────────────
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-southeast-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "create_ec2" {
  description = "Whether to create the EC2 instance"
  type        = bool
  default     = true
}

variable "ami_map" {
  description = "Map of environment ⇒ AMI ID"
  type        = map(string)
  default = {
    dev  = "ami-04173560437081c75"  # Amazon Linux
    prod = "ami-069cb3204f7a90763"  # Ubuntu
  }
}

#───────────────────────────────────────────────────────────────────────────────
# LOCALS & CONDITIONAL EXPRESSIONS
#───────────────────────────────────────────────────────────────────────────────
locals {
  # Pick instance size based on environment
  instance_type = var.environment == "prod" ? "t3.micro" : "t2.micro"

  # Size the root volume larger in prod
  root_volume_size = var.environment == "prod" ? 10 : 8

  # Build tags differently if we’re in prod vs dev
  common_tags = {
    Name        = "terraform-${var.environment}"
    Environment = var.environment
    Billing     = var.environment == "prod" ? "Team-EC2-Prod" : "Team-EC2-Dev"
  }
}

#───────────────────────────────────────────────────────────────────────────────
# RESOURCE: EC2 INSTANCE
#───────────────────────────────────────────────────────────────────────────────
resource "aws_instance" "example" {
  # Conditionally create zero or one instance
  count         = var.create_ec2 ? 1 : 0

  ami           = lookup(var.ami_map, var.environment)
  instance_type = local.instance_type

  root_block_device {
    volume_size           = local.root_volume_size
    delete_on_termination = true
  }

  tags = local.common_tags
}

#───────────────────────────────────────────────────────────────────────────────
# OUTPUTS
#───────────────────────────────────────────────────────────────────────────────
output "instance_ids" {
  description = "IDs of the EC2 instances created (if any)"
  value       = aws_instance.example[*].id
}

