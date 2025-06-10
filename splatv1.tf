provider "aws" {
   region     = "ap-south-1"
}

# Create multiple EC2 instances via count
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
}

# Use a splat to get all of their IDs
output "web_instance_ids" {
  value = aws_instance.web[*].id
}
