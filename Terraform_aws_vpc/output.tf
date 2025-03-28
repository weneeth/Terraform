output "loadbalancerdns" {
    value = aws_lb.myLB.dns_name
  
}

output "instance1_public_ip" {
    value = aws_instance.myInstance1.public_ip
  
}

output "instance2_public_ip" {
    value = aws_instance.myInstance2.public_ip
  
}
