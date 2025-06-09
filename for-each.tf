provider "aws" {
   region     = "ap-south-1"
}

resource "aws_instance" "ec2_example" {

    for_each = {
      instance1 = "t2.micro"
      instance2 = "t3.micro"
    }

   ami           = "ami-0f535a71b34f2d44a"
   instance_type =  each.value

   tags = {
           Name = "Terraform ${each.key}"
   }
}

