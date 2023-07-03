data "aws_iam_role" "LabRole" {
  name = "LabRole"
}

resource "aws_eks_cluster" "oblimanual-kluster" {
  name     = "oblimanual-kluster"
  role_arn = data.aws_iam_role.LabRole.arn
  version  = 1.22   #LE TUVE QUE BAJAR LA VERSION DEL KLUSTER PORQUE HAY DRAMA CON LOS VOLUMES (https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
  vpc_config {
    subnet_ids = [aws_subnet.oblimanual-subnet1-publica.id, aws_subnet.oblimanual-subnet2-publica.id]
  }
  #cluster_endpoint_public_access  = true
}

# Se crea el Node Group donde se levantarán los Workers de EKS.
# Para la creación de este recurso se indica el Cluster donde 
# trabajara, se le asigna un nombre y el ARN del Role a utilizar.
# A su vez se le indica las subnets en las que se hará el deploy.
# Estas subnets están en diferentes AZ, logrando así redundancia del servicio.

resource "aws_eks_node_group" "oblimanual-kluster-ng" {
  cluster_name    = aws_eks_cluster.oblimanual-kluster.name
  node_group_name = "oblimanual-kluster-ng"
  node_role_arn   = data.aws_iam_role.LabRole.arn
  subnet_ids      = [aws_subnet.oblimanual-subnet1-publica.id, aws_subnet.oblimanual-subnet2-publica.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

}

