variable "ami_id" {
  description = "Ubuntu AMI ID for us-east-1"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}