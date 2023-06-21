# aca vamos a ir escribiendo el bendito script 

#!/bin/bash

# Este script instala con un poco de suerte, Docker y kubectl en Amazon Linux


# 0. Variables:
# 4. Creo una variable con el uri ID del repo
ECR_ID=`aws ecr describe-repositories --repository-names cartservice --query 'repositories[].repositoryUri' --output text | cut -d "/" -f1`

SRC_WORKDIR="/tmp/obli_deploy/src/"

MICROSERVICES=(
  "adservice"
  "cartservice"
  "checkoutservice"
  "currencyservice"
  "emailservice"
  "frontend"
  "loadgenerator"
  "paymentservice"
  "productcatalogservice"
  "recommendationservice"
  "redis"
  "shippingservice"
)


# 1. Instalar Docker
sudo dnf install telnet docker -y 
sudo usermod -a -G docker ec2-user
sudo systemctl enable --now docker
sudo chmod 666 /var/run/docker.sock

# 2. Instalar kubectl
sudo curl --silent --location -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl --silent --location https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl

# 3. Hago el build de las imagenes


for service in "${MICROSERVICES[@]}"
do
  echo "Haciendo el build para: $service..."
  if [[ "$service" == "cartservice" ]]; then
    cd "$SRC_WORKDIR$service/src" || continue
  else
    cd "$SRC_WORKDIR$service" || continue
  fi
  docker build -t "$service" .
  cd ../..
done


# 4. Ahora nos logueamos al registry con docker
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_ID

# 5 hacemos el build de las imagenes

for service in "${MICROSERVICES[@]}"
do
  echo "Haciendo el build para: $service..."
  if [[ "$service" == "cartservice" ]]; then
    cd "$SRC_WORKDIR$service/src" || continue
  else
    cd "$SRC_WORKDIR$service" || continue
  fi
  docker build -t "$service" .
  docker tag $service:latest $ECR_ID/$service:latest
  docker push $ECR_ID/$service:latest
  cd ../..
done

#ESTO LO VOY A PRECESIAR DESPUES
aws eks update-kubeconfig --region us-east-1 --name oblimanual-kluster

#Aca le cambio el tag a los manifest de kubernetes
for service in "${MICROSERVICES[@]}"
do
  echo "Cambio el tag en el Manifest de: $service..." 
  cd "$SRC_WORKDIR/$service/deployment"
  sudo sed -i "s/<IMAGE:TAG>/$ECR_ID\/$service:latest/g" kubernetes-manifests.yaml  
  cd ../..
done


#Y aca si anda todo, levanto los deploys....
for service in "${MICROSERVICES[@]}"
do
  echo "Deployando: $service..." 
  cd "$SRC_WORKDIR/$service/deployment"  
  kubectl create -f kubernetes-manifests.yaml
  cd ../..
done
echo "listo"



