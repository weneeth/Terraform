terraform {
  backend "s3" {
    bucket         = "terraform-aws-vpc1" # Replace with your S3 bucket name
    key            = "Terraform/terraform.tfstate" # Replace with your desired state file path
    region         = "us-east-1"  # Replace with your DynamoDB table for state locking
    
  }
}