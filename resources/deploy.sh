# aca vamos a ir escribiendo el bendito script 

#!/bin/bash

# Este script instala con un poco de suerte, Docker y kubectl en Amazon Linux

# 1. Instalar Docker
sudo dnf install docker -y 
sudo usermod -a -G docker ec2-user
sudo systemctl enable --now docker
sudo chmod 666 /var/run/docker.sock


# 2. Instalar kubectl
sudo curl --silent --location -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl --silent --location https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl

# 3. Hago el build de las imagenes





#cartservice

#esto esta resuelto en terraform
#aws ecr create-repository --repository-name cartservice

#creo una variable con el uri ID del repo
ECR_ID=`aws ecr describe-repositories --repository-names cartservice --query 'repositories[].repositoryUri' --output text | cut -d "/" -f1`
aws ecr describe-repositories --repository-names cartservice --query 'repositories[].repositoryUri' --output text | cut -d "/" -f1 > ~/url
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(cat ~/url)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_ID
cd /tmp/obli_deploy/src/cartservice/src
docker build -t cartservice .
docker tag cartservice:latest $(cat ~/url)/cartservice:latest
docker push $(cat ~/url)/cartservice:latest

#adservice
# aws ecr create-repository --repository-name adservice
# cd /tmp/obli_deploy/src/adservice
# docker build -t adservice .
# docker tag adservice:latest $ECR_ID/adservice:latest
# docker push $ECR_ID/adservice:latest


