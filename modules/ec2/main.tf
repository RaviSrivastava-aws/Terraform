resource "aws_instance" "test_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "test-ec2"
  }
}