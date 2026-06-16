terraform {
  backend "s3" {
    bucket         = "my-tf-test-s3bucet-for-dev"
    key            = "terraform/github-actions/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}