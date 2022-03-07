output "alb_sg_id" {
  value     = aws_security_group.alb.id
  sensitive = false
}

output "api_users_sg_id" {
  value     = aws_security_group.app.id
  sensitive = false
}
