resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr  
    enable_dns_support = true
    enable_dns_hostnames = true 

    tags = {
        Name = "Terraform_VPC"
    }
}

resource "aws_subnet" "subnet1"{
    vpc_id = aws_vpc.myvpc.id 
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myIGW" {
    vpc_id = aws_vpc.myvpc.id
  
}

resource "aws_route" "myRT" {
    route_table_id = aws_vpc.myvpc.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id  
    
}

resource "aws_route_table_association" "rtsb1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_vpc.myvpc.default_route_table_id
  
}

resource "aws_route_table_association" "rtsb2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_vpc.myvpc.default_route_table_id
  
}

resource "aws_security_group" "mySecGrp" {
    vpc_id = aws_vpc.myvpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
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

resource "aws_instance" "myInstance1" {
    ami = var.aws_ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.mySecGrp.id]
    subnet_id = aws_subnet.subnet1.id
    user_data = filebase64("userdata1.sh")
    tags = {
        Name = "Terraform_instance1"
    }
  
}

resource "aws_instance" "myInstance2" {
    ami = var.aws_ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.mySecGrp.id]
    subnet_id = aws_subnet.subnet2.id
    user_data = filebase64("userdata2.sh")
    tags = {
        Name = "Terraform_instance2" 
    }
  
}

resource "aws_lb" "myLB" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.mySecGrp.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "MyLoadBalancer"
  }
}

resource "aws_lb_target_group" "myTG" {
    name     = var.target_group_name
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.myvpc.id

    health_check {
        path                = "/"
        port                = "traffic-port"
    }
  
}

resource "aws_lb_listener" "myListener" {
    load_balancer_arn = aws_lb.myLB.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.myTG.arn
        type             = "forward"
    }
  
}

resource "aws_lb_target_group_attachment" "instance1_attachment" {
    target_group_arn = aws_lb_target_group.myTG.arn
    target_id        = aws_instance.myInstance1.id
    port             = 80
  
}

resource "aws_lb_target_group_attachment" "instance2_attachment" {
    target_group_arn = aws_lb_target_group.myTG.arn
    target_id        = aws_instance.myInstance2.id
    port             = 80
  
}

output "loadbalancerdns" {
    value = aws_lb.myLB.dns_name
  
}

