provider "aws" {
   region     = "ap-south-1"
}

locals {
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
}

resource "aws_subnet" "public" {
  for_each = toset(local.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  for_each = toset(local.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}
