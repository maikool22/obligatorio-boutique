resource "aws_ecr_repository" "my_repositories" {
  count = length(var.repository_names)
  name  = var.repository_names[count.index]
}
