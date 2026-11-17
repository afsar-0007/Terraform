

# STEP 1: Configure AWS Provider

provider "aws" {
  region = "us-east-1"
}

# STEP 2: Fetch existing Default VPC

data "aws_vpc" "default" {
  default = true
}

# STEP 3: Fetch subnets inside Default VPC

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"

    values = [data.aws_vpc.default.id]
  }
}

# STEP 4: Create EC2 Instance

resource "aws_instance" "my_ec2" {
  ami           = "ami-0547ecbf0e9b4aeb5"
  instance_type = "t3.micro"

  subnet_id = data.aws_subnets.default.ids[0]

  tags = {
    Name = "Terraform-EC2"
  }
}
