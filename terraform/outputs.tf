output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "instance_id" {
  value = aws_instance.app_server.id
}

output "app_url" {
  value = "http://${aws_instance.app_server.public_ip}"
}

output "jenkins_url" {
  value = "http://${aws_instance.app_server.public_ip}:8080"
}

output "security_group_id" {
  value = aws_security_group.app_sg.id
}
