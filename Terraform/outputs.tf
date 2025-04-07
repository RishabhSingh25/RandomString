output "app_url" {
  value = "http://${aws_eip.app_eip.public_ip}:8081/api/v1"
}