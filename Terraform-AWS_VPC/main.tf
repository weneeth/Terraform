resource "aws_vpc" "VPC1" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true   
    enable_dns_hostnames = true
    tags = {
        name = "Terraform_VPC"
    }  
}

resource "aws_key_pair" "TF_key_pair" {
    key_name = "my_TF_key_pair"
    public_key = file("VPC1_key.pub")   #ssh-keygen -t rsa -b 4096 -f "(define you path here)"  to generate your key pair
  
}

resource "aws_subnet" "subnet_VPC1" {
    vpc_id = aws_vpc.VPC1.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      name = "subnet_VPC1"
    }
  
}

resource "aws_internet_gateway" "IGW_VPC1" {
    vpc_id = aws_vpc.VPC1.id
    tags = {
        name = "IGW_VPC1"
    }
  
}

resource "aws_route_table" "RT_VPC1" {
    vpc_id = aws_vpc.VPC1.id
    tags = {
        name = "RT_VPC1"
}
}

resource "aws_route" "default_route" {
    route_table_id         = aws_route_table.RT_VPC1.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.IGW_VPC1.id
}

resource "aws_route_table_association" "RT_Association" {
    subnet_id = aws_subnet.subnet_VPC1.id
    route_table_id = aws_route_table.RT_VPC1.id
  
}

resource "aws_security_group" "SG_VPC1" {
    vpc_id = aws_vpc.VPC1.id
    tags = {
      name = "SG_VPC!"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80    
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "EC2-1" {
    ami = "ami-08b5b3a93ed654d19"  # Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-0c55b159cbfafe1f0
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet_VPC1.id
    key_name = aws_key_pair.TF_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.SG_VPC1.id]
    tags = {
        name = "EC2-1"
    }
  
}

# resource "aws_s3_bucket" "TFbucket" {
#   bucket = "terraform-aws-vpc1"  
# }

resource "aws_dynamodb_table" "DyDB_VPC1" {
    name = "DyDB_VPC1"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
        name = "LockID"
        type = "S"
    }
    hash_key = "LockID"
    tags = {
        name = "DyDB_VPC1"
    }
  
}