terraform {
    backend "s3" {
        bucket         = "terraform-aws-vpc1" 
        key            = "Terraform/terraform.tfstate"  
        region         = "us-east-1"   
        dynamodb_table = "DyDB_VPC1"
        encrypt        = true
    }
  
}