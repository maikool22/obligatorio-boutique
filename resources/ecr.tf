#Aca creamos los repositorios de ECS necesarios usando una variable de tipo array definida con los nombres de los
#repos, entonces cuando ejecuta el resource crea un repo por posicion del array.
resource "aws_ecr_repository" "my_repositories" {
  count = length(var.repository_names)
  name  = var.repository_names[count.index]
}