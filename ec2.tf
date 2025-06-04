terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}
 
variable "region" {

    type = string

    default = "us-east-1"

}
 
variable "ami" {

    type = string

    default = "ami-084568db4383264d4"

}
 
variable "instance" {

    type = string

    default = "t2.micro"

}
 
 
provider "aws" {

region = var.region

}
 
resource "aws_instance" "myec2" {

    ami = var.ami

    instance_type = var.instance
 
    tags = {

        Name = "tf-launch-11"

    }

}
 
