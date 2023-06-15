###############
# Creamos VPC #
###############

resource "aws_vpc" "oblimanual" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "oblimanual-vpc"
  }
}

############################################################################
# Creamos subnets, una privada y una publica por ZA para tener redundancia #
############################################################################

# us-east-1a

resource "aws_subnet" "oblimanual-subnet1-publica" {
  vpc_id                  = aws_vpc.oblimanual.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "oblimanual-subnet1-publica"
  }
}

resource "aws_subnet" "oblimanual-subnet1-privada" {
  vpc_id                  = aws_vpc.oblimanual.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "oblimanual-subnet1-privada"
  }
}

# us-east-1b

resource "aws_subnet" "oblimanual-subnet2-publica" {
  vpc_id                  = aws_vpc.oblimanual.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "oblimanual-subnet2-publica"
  }
}
resource "aws_subnet" "oblimanual-subnet2-privada" {
  vpc_id                  = aws_vpc.oblimanual.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "oblimanual-subnet2-privada"
  }
}

##############################
# Creamos el internet gateway#
##############################

resource "aws_internet_gateway" "oblimanual-ig" {
  vpc_id = aws_vpc.oblimanual.id
  tags = {
    Name = "oblimanual-ig"
  }
}

########################
#Creamos tabla de ruteo#
########################

resource "aws_route_table" "oblimanual-rt" {
  vpc_id = aws_vpc.oblimanual.id

  tags = {
    Name = "oblimanual-rt"
  }
}

#Agregamos ruta por defecto para que pueda salir por el internet gateway

resource "aws_route" "oblimanual-default-route" {
  route_table_id         = aws_route_table.oblimanual-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.oblimanual-ig.id
}

#Asociamos subnets a la tabla de ruteo

resource "aws_route_table_association" "oblimanual-rt-assoc1" {
  subnet_id      = aws_subnet.oblimanual-subnet1-publica.id
  route_table_id = aws_route_table.oblimanual-rt.id
}
resource "aws_route_table_association" "oblimanual-rt-assoc2" {
  subnet_id      = aws_subnet.oblimanual-subnet1-privada.id
  route_table_id = aws_route_table.oblimanual-rt.id
}
resource "aws_route_table_association" "oblimanual-rt-assoc3" {
  subnet_id      = aws_subnet.oblimanual-subnet2-publica.id
  route_table_id = aws_route_table.oblimanual-rt.id
}
resource "aws_route_table_association" "oblimanual-rt-assoc4" {
  subnet_id      = aws_subnet.oblimanual-subnet2-privada.id
  route_table_id = aws_route_table.oblimanual-rt.id
}

