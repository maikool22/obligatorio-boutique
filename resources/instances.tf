# Creamos el bastion

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  root_block_device {  # ampliamos la capacidad de disco por defecto de 8 a 16 GB
    volume_size = 16
  }
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

  #no nos quedo de otra que copiar asi las credenciales, sino no andaba :P
  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ec2-user/.aws"
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
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl hostname bastion",                 #Le configuramos nombre al bastion
      "sudo dnf -y upgrade --releasever=2023.0.20230614",  #Actualizamos el core de la ami de linux     
      "sudo yum install -y git",                           # Instalamos git      
      "sudo mkdir /tmp/obli_deploy/",                      #creamos carpeta temporal en el bastion
      "sudo git clone https://github.com/damiansandoval/obligatorio-boutique --branch testing /tmp/obli_deploy/", # clonamos el repo que vamos a usar
      "cd /tmp/obli_deploy/resources",                     #nos cambiamos al workdir
      "sudo chmod +x /tmp/obli_deploy/resources/deploy.sh",# le doy permisos de ejecucion al script
      "sudo chmod -R 777 /tmp/obli_deploy/", # le doy permisos a toda la carpeta del deploy
      "bash deploy.sh" #Ejecutamos el deploy de los modulos
    ]
  }
}
