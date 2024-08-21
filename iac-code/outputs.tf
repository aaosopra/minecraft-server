##################################################################################
# OUTPUT
##################################################################################

output "aws_lb_public_dns" {
  value       = "http://${aws_instance.django1.public_dns}"
  description = "Public DNS URL"
}

output "webapp_instance0_public_ip" {
  value = aws_instance.django1.public_ip
}
