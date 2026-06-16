variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "ami_id" {
  type    = string
  default = "ami-0f918f7e67a3323f0"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "bucket_name" {
  type    = string
  default = "my-tf-test-s3bucket-for-pre-prodss"
}
