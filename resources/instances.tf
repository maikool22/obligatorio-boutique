# Creamos el bastion

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "vockey"
  subnet_id              = aws_subnet.oblimanual-subnet1-publica.id
  vpc_security_group_ids = [aws_security_group.oblimanual-sg.id]
  tags = {
    Name      = "bastion"
    terraform = "True"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("./vockey.pem")
  }



  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl hostname bastion",  #Le configuramos nombre al bastion
      "sudo dnf -y upgrade --releasever=2023.0.20230614", #Actualizamos el core de la ami de linux     
      "sudo yum install -y git", # Instalamos git
      "mkdir /home/ec2-user/.aws",
      "sudo mkdir /tmp/obli_deploy/", #creamos carpeta temporal en el bastion
      "sudo git clone https://github.com/maikool22/obligatorio-boutique.git /tmp/obli_deploy/", # clonamos el repo que vamos a usar
      "cd /tmp/obli_deploy/", #nos cambiamos al workdir
      "echo hola!" #aca ejecutamos el deploy de los modulos



      #"sudo touch /var/www/html/index.html",       # creo el index.html vacio
      #"sudo chmod 666 /var/www/html/index.html",   # cambio permisos
      #"sudo echo nodo1 > /var/www/html/index.html" # hago un echo con el nombre del nodo y se lo pongo en el archivo
    ]
  }
    provisioner "file" {
    source      = "/home/damian/.aws/credentials"
    destination = "/home/ec2-user/.aws/credentials"
  }
    provisioner "file" {
    source      = "/home/damian/.aws/config"
    destination = "/home/ec2-user/.aws/config"
  }
}