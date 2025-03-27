variable "cidr" {
  default = "10.0.0.0/16"
  
}

variable "aws_ami" {
  description = "AMI ID"
  type = string
  
}

variable "instance_type" {
  description = "Instance type"
  type = string
  
  
}

variable "key_name" {
  description = "Key pair name"
  type = string
   
  
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

 