
data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}



resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "terraform-nginx-key"
  public_key = tls_private_key.my_key.public_key_openssh
}



resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "${path.module}/terraform-nginx-key.pem"
  file_permission = "0600"
}



resource "aws_security_group" "nginx_sg" {
  name        = "terraform-nginx-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id



  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Nginx-SG"
  }
}

resource "aws_instance" "my_ec2" {

  ami           = var.ami_id
  instance_type = var.ec2_instance_type

  subnet_id = data.aws_subnets.default.ids[0]

  associate_public_ip_address = true



  key_name = aws_key_pair.my_key_pair.key_name



  vpc_security_group_ids = [
    aws_security_group.nginx_sg.id
  ]

  user_data = file("${path.module}/install_nginx.sh")

  tags = {
    Name = "Terraform-Nginx-EC2"
  }

  depends_on = [
    local_sensitive_file.private_key
  ]
}