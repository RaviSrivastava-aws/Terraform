terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "test_ec2" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"

  tags = {
    Name = "test-ec2"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-s3bucet-for-dev"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}