terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Recommended: Use latest stable version
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Default region
}