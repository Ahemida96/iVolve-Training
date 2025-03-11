output "aws_instances" {
  value = aws_instance.this.public_ip
}