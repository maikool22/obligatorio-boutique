output "role_arn" {
  value = data.aws_iam_role.LabRole.arn
}

output "public_ip" {
  value = aws_instance.bastion.public_ip
}