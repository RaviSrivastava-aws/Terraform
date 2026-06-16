terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
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
  bucket = "my-tf-test-s3bucket-for-productions"

  tags = {
    Name        = "My bucket"
    Environment = "production"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "lambda_execution_role_test"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "example" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda/fix.zip"
}

resource "aws_lambda_function" "example" {
  filename         = data.archive_file.example.output_path
  function_name    = "example_lambda_function"
  role             = aws_iam_role.example.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.example.output_base64sha256

  runtime = "nodejs24.x"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "production"
    Application = "example"
  }
}