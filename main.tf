provider "aws" {
  region = "us-east-1"  
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
 
resource "aws_instance" "this" {
  ami                     = "ami-08b5b3a93ed654d19"
  instance_type           = "t2.micro" 
  key_name                = "EC2 Beginner"
  vpc_security_group_ids = ["sg-0d4f780e21df694a3"]
  tags = {
    Name = "Terraform_instance" 
  } 

}