output "web_server_ip" {
  description = "Public IP of web_server instance"
  value       = aws_instance.web_server.public_ip
}

output "app_ip" {
  description = "Public IP of app instance"
  value       = aws_instance.app.public_ip
}

output "route53_name_servers" {
  description = "NS servers for aws subdomain"
  value       = aws_route53_zone.aws_subdomain.name_servers
}