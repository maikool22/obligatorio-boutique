#!/bin/bash

# El siguiente script se encarga de la instalación
# de Docker y Kubectl en la instancia Bastion.
# Luego de esto, se realiza el build de las imágenes de cada componente
# y las mismas son publicadas en el registro ya creado en código de Terraform.
# Por último, se realiza el despliegue mediante kubectl.

# Variables:

# Creo una variable con el ID del repositorio URI.
# Dado que el comando "aws ecr describe-repositories" devuelve el nombre completo del repositorio,
# y solo necesitamos la URL sin el nombre del módulo, optamos por utilizar "cut" para obtener solo el ID.

ECR_ID=$(aws ecr describe-repositories --repository-names cartservice --query 'repositories[].repositoryUri' --output text | cut -d "/" -f1)

# Generamos una variable indicando la subcarpeta donde están los datos para la construcción y despliegue de las imágenes.
SRC_WORKDIR="/tmp/obli_deploy/src/"
sudo chown -R ec2-user:ec2-user /tmp/obli_deploy/
sudo chmod -R 770 $SRC_WORKDIR


# Definimos una variable de tipo lista con los nombres de módulos para ser recorridos más adelante con bucles for.

# MICROSERVICES=(
#   "adservice"
#   "cartservice"
#   "checkoutservice"
#   "currencyservice"
#   "emailservice"
#   "frontend"
#   "loadgenerator"
#   "paymentservice"
#   "productcatalogservice"
#   "recommendationservice"
#   "redis"
#   "shippingservice"
# )


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
  "shippingservice"
)


# Instalamos Docker
sudo dnf install telnet docker -y 
sudo usermod -a -G docker ec2-user
sudo systemctl enable --now docker
sudo chmod 666 /var/run/docker.sock

# Instalamos kubectl
sudo curl --silent --location -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl --silent --location https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl

# Con este bucle for, recorremos los diferentes directorios "src" de cada módulo
# realizando el build de la imagen correspondiente.

# Ahora nos logueamos al registry con docker
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_ID


sleep 30s


# Hacemos el build de las imagenes

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

# Aquí registramos Kubernetes contra nuestro clúster previamente creado en Terraform.
aws eks update-kubeconfig --region us-east-1 --name oblimanual-kluster

# Recorremos todos los manifiestos de cada aplicación y reemplazamos "IMAGE" por la URL de la imagen y "TAG" por "latest".
for service in "${MICROSERVICES[@]}"
do
  echo "Cambio el tag en el Manifest de: $service..." 
  cd "$SRC_WORKDIR$service/deployment"
  aux=$(aws ecr describe-repositories --repository-names $service --query 'repositories[].repositoryUri' --output text)
  echo $aux
  sed -i "s|<IMAGE:TAG>|$aux:latest|g" kubernetes-manifests.yaml  
done



sleep 60s


# #### Como no se como formatear una ebs en terraform lo tengo que hacer aca....
# #### Esto para formatear el ebs que luego voy a utilizar con redis-pv
sudo pvcreate /dev/xvdf
sudo vgcreate redis-vg /dev/xvdf
sudo lvcreate -l 100%FREE -n redis-lv redis-vg
sudo mkfs.ext4 /dev/redis-vg/redis-lv
sudo mount /dev/redis-vg/redis-lv /data

# #### Forma muy rustica de sacar el volume ID
# VOLUME_ID=$(aws ec2 describe-volumes --filters Name=attachment.device,Values=/dev/xvdf --output text | grep attached | cut -d "       " -f7)

##Forma menos rustica
VOLUME_ID=$(aws ec2 describe-volumes --filters Name=tag:Name,Values=oblimanual-redis-ebs --query "Volumes[*].{ID:VolumeId}" --output text)

echo $VOLUME_ID

#### Por ultimo voy al manifest del redis y le cambio el <AWS_EBS_VOLUME_ID> por el id que me devolvio la variable VOLUME-ID
# cd "$SRC_WORKDIR/redis/deployment"
# sed -i "s|<AWS_EBS_VOLUME_ID>|$VOLUME_ID|g" kubernetes-manifests.yaml


# Por último, recorremos nuevamente cada carpeta "deployment" y ejecutamos "kubectl" para cada módulo.
for service in "${MICROSERVICES[@]}"
do
  echo "Deployando: $service..." 
  cd "$SRC_WORKDIR$service/deployment"  
  kubectl create -f kubernetes-manifests.yaml 

done

# Con la siguiente variable, indicaremos el endpoint generado por el Load Balancer de Kubernetes.
# Podemos utilizar esta URL en el navegador para acceder a la tienda.
ENDPOINT=$(kubectl get -o json svc frontend-external | grep hostname)


echo ""
echo "#########################################################################################################################"
echo "ENDPOINT:  "$ENDPOINT
echo "#########################################################################################################################"
echo ""

