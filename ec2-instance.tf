# Terraform Settings Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.21" # Optional but recommended in production
    }
    
  }
  # backend "s3" {
  #   bucket = "i-named-this-bucket-157673692367-0"
  #   key    = "state-file/terraform.state"
  #   region = "ap-south-1"
  # }
}

# Provider Block
provider "aws" {
  profile = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
  region  = "ap-south-1"
}

# Resource Block
# resource "aws_instance" "ec2demo" {
#   ami           = "ami-01216e7612243e0ef" # Amazon Linux in us-east-1, update as per your region
#   instance_type = "t2.micro"
# }


# resource "aws_s3_bucket" "b" {
#   bucket = "my-tf-test-bucket-xy5142874"

#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }