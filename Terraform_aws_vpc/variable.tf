variable "cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "values of availability zones"
  type = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]  
  
}

variable "aws_ami" {
  description = "AMI ID"
  type = string
  default = "ami-08b5b3a93ed654d19"
  
}

variable "instance_type" {
  description = "Instance type"
  type = string
  default = "t2.micro"
  
}

variable "key_name" {
  description = "Key pair name"
  type = string
  default = "EC2 Beginner"
  
}

variable "load_balancer_type" {
  description = "Type of load balancer"
  type = string
  default = "application"
  
}

variable "target_group_name" {
  description = "Name of target group"
  type = string
  default = "myTargetGroup"
  
}

 