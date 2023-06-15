# Creamos dos intancias

resource "aws_instance" "oblimanual-inst1" {
  ami                    = var.ami-id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  subnet_id              = aws_subnet.oblimanual-subnet1-publica.id
  vpc_security_group_ids = [aws_security_group.oblimanual-sg.id]
  tags = {
    Name      = "oblimanual-inst1"
    terraform = "True"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("./vockey.pem")
  }

  # Dejamos prontos los servicio de git y httpd

  provisioner "remote-exec" {
    inline = [
      "yum update -y",
      "sudo yum install -y git"             # -y lo que hace es no pedir confirmacion, instalo httpd y git
      #"sudo touch /var/www/html/index.html",       # creo el index.html vacio
      #"sudo chmod 666 /var/www/html/index.html",   # cambio permisos
      #"sudo echo nodo1 > /var/www/html/index.html" # hago un echo con el nombre del nodo y se lo pongo en el archivo
    ]
  }
}

resource "aws_instance" "oblimanual-inst2" {
  ami                    = var.ami-id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  subnet_id              = aws_subnet.oblimanual-subnet2-publica.id
  vpc_security_group_ids = [aws_security_group.oblimanual-sg.id]
  tags = {
    Name      = "oblimanual-inst2"
    terraform = "True"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("./vockey.pem")
  }

  # Dejamos prontos los servicio de git y httpd

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y httpd git",             # -y lo que hace es no pedir confirmacion, instalo httpd y git
      "sudo systemctl start httpd",                # arranco el servicio httpd
      "sudo systemctl start httpd",                # dejo habilitado el servicio httpd
      "sudo touch /var/www/html/index.html",       # creo el index.html vacio
      "sudo chmod 666 /var/www/html/index.html",   # cambio permisos
      "sudo echo nodo2 > /var/www/html/index.html" # hago un echo con el nombre del nodo y se lo pongo en el archivo
    ]
  }
}