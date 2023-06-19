#Aca creamos los repositorios de ECS necesarios usando una variable de tipo array definida con los nombres de los
#repos, entonces cuando ejecuta el resource crea un repo por posicion del array.

resource "aws_ecr_repository" "my_repositories" {
  count = length(var.repository_names)
  name  = var.repository_names[count.index]
}

#aca le pedimos a chatgpt aiuda, necesitamos obtener por un output los id de los repos y la url para ver como hacemos para publicar las imagenes que buildeamos con docker
# output "ecr_repository_details" {
#   value = [
#     for idx, name in var.repository_names : {
#       name           = name
#       repository_id  = aws_ecr_repository.my_repositories[idx].id
#       repository_url = aws_ecr_repository.my_repositories[idx].repository_url
#     }
#   ]
# }

# output "ecr_repository_details" {
#   value = [
#     for idx, name in var.repository_names : {
#       name           = name
#       repository_id  = aws_ecr_repository.my_repositories[idx].id
#       repository_url = replace(aws_ecr_repository.my_repositories[0].repository_url,"", "")
#     }
#   ]
# }