# aca vamos a ir escribiendo el bendito script 

#!/bin/bash

# Este script instala con un poco de suerte, Docker y kubectl en Amazon Linux, hace el build, pushea a la registry y despliega en el kluster


# 0. Variables:

# 4. Creo una variable con el uri ID del repo
# como el comando "aws ecr describre-repositories me trae todo el nombre del repo y solo
# necesitabamos la url sin el nombre del modulo, optamos por hacer un "cut" para solo obtener el ID"

ECR_ID=$(aws ecr describe-repositories --repository-names cartservice --query 'repositories[].repositoryUri' --output text | cut -d "/" -f1)

# la subcarpeta donde estan los datos para la construccion y despliegue de las imagenes.
SRC_WORKDIR="/tmp/obli_deploy/src/"
sudo chmod -R 777 /tmp/obli_deploy
#Aca hacemos una lista con los modulos para despues llamarla con un "for"

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

# 1. Instalamos Docker
sudo dnf install telnet docker -y 
sudo usermod -a -G docker ec2-user
sudo systemctl enable --now docker
sudo chmod 666 /var/run/docker.sock

# 2. Instalamos kubectl
sudo curl --silent --location -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl --silent --location https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl

# 3. Con este for, recorro los diferentes directorios src de cada modulo
# haciendo el Build de imagencorrespondiente

for service in "${MICROSERVICES[@]}"
do
  echo "Haciendo el build para: $service..."
  if [[ "$service" == "cartservice" ]]; then
    cd "$SRC_WORKDIR$service/src" || continue
  else
    cd "$SRC_WORKDIR$service" || continue
  fi
  docker build -t "$service" .
done


# 4. Ahora nos logueamos al registry con docker
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_ID
echo $ECR_ID


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
  docker tag "$service:latest" "$ECR_ID/$service:latest"
  docker push "$ECR_ID/$service:latest"
done

#ESTO LO VOY A PRECESIAR DESPUES
aws eks update-kubeconfig --region us-east-1 --name oblimanual-kluster

#Aca le cambio el tag a los manifest de kubernetes
for service in "${MICROSERVICES[@]}"
do
  echo "Cambio el tag en el Manifest de: $service..." 
  cd "$SRC_WORKDIR/$service/deployment"
  aux=$(aws ecr describe-repositories --repository-names $service --query 'repositories[].repositoryUri' --output text)
  echo $aux
  sed -i "s|<IMAGE:TAG>|$aux:latest|g" kubernetes-manifests.yaml  
done


#Y aca si anda todo, levanto los deploys....
for service in "${MICROSERVICES[@]}"
do
  echo "Deployando: $service..." 
  cd "$SRC_WORKDIR/$service/deployment"  
  kubectl create -f kubernetes-manifests.yaml 

done
echo "pronto!"

ENDPOINT=$(kubectl get -o json svc frontend-external | grep hostname)

echo: ""
echo: ""
echo: ""
echo: "###################################################################################"
echo: "el endpoint de la tienda es:  "$ENDPOINT
echo: "###################################################################################"
echo: ""
echo: ""
echo: ""

