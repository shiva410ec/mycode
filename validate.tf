terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.99"
    }
  }
}

provider "aws" {
  # We’re pointing at a real AWS region…
  region = "us-east-1"
}

resource "aws_instances" "web" {
  ami           = "ami-02457590d33d576c3"
  instance_type = "t3.micro"

  tags = {
    Name = "validate-vs-plan-demo"
  }
}
