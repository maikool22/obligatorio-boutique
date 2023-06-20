resource "aws_eks_cluster" "oblimanual-kluster" {
  name = "oblimanual-kluster"
  role_arn = var.aws_iam_role.prueba.id
  vpc_config {
    subnet_ids = [oblimanual-subnet1-publica.id, oblimanual-subnet2-publica.id]
  }
  
}



resource "aws_iam_role" "LabRole" {
  name = "LabRole"
}

