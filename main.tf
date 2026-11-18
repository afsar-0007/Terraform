provider "aws" {
  region = "us-east-1"

}
modules "ec2_instance" {
  source = "./modules/ec2_instance"

  ami_id            = "ami-0c02fb55956c7d316" # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
  ec2_instance_type = "t3.micro"
  my_ip             = "YOUR_PUBLIC_IP/32" # Replace with your actual public IP address
}