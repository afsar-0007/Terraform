
output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.my_ec2.public_ip
}

output "website_url" {
  description = "Nginx Website URL"
  value       = "http://${aws_instance.my_ec2.public_ip}"
}

output "ssh_command" {
  description = "SSH connection command"
  value       = "ssh -i terraform-nginx-key.pem ubuntu@${aws_instance.my_ec2.public_ip}"
}