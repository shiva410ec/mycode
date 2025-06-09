provider "aws" {
  region = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment: dev or prod"
  type        = string
  default     = "dev"
}

variable "ami_dev" {
  type    = string
  default = "ami-0f535a71b34f2d44a"
}

variable "ami_prod" {
  type    = string
  default = "ami-02521d90e7410d9f0"
}

resource "aws_instance" "example" {
  ami           = var.environment == "prod" ? var.ami_prod : var.ami_dev
  instance_type = "t2.micro"
}
