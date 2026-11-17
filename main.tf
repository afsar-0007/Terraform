



provider "aws" {
  region = "us-east-1"
}



data "aws_vpc" "default" {
  default = true
}



data "aws_subnets" "default" {
  filter {
    name = "vpc-id"

    values = [data.aws_vpc.default.id]
  }
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0547ecbf0e9b4aeb5"
  instance_type = "t3.micro"

  subnet_id = data.aws_subnets.default.ids[0]

  tags = {
    Name = "Terraform-EC2"
  }
}
