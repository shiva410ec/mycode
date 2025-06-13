provider "aws" {
   region     = "us-east-1"
}
 
resource "aws_instance" "ec2_example" {
 
    for_each = {
      instance1 = "t2.micro"
      instance2 = "t3.micro"
    }
 
   ami           = "ami-020cba7c55df1f615"
   instance_type =  each.value
 
   tags = {
           Name = "Terraform-cloud ${each.key}"
   }
}