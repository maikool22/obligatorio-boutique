
<h1 align="center"> BOUTIQUE ONLINE </h1>

---
# Descripcion del Problema:
La startup "e-shop Services" ha recibido una ronda de inversión para expandir sus operaciones por todo el mundo, haciendo llegar sus servicios de e-commerce y retail, a todo el continente de América.La competencia actualmente está posicionada en la región a la cual se quiere expandir, pero los inversionistas están presionado para que  "e-shop Services" expanda su marca ya que de esto depende seguir invirtiendo.Se ha contratado a la consultora BitBeat para modernizar y desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise.Una célula de desarrollo trabajó en la implementación del e-commerce basado en una arquitectura de microservicios para correr sobre containers cuyo ciclo de integración continua ya que se encuentra configurado y la solución ya se encuentra disponible para desplegar por parte del equipo de DevOps.

# Descripción de la Solucion:
El proyecto de la Tienda Online es un sistema de comercio electrónico que permite a los usuarios comprar productos en línea. Proporciona una plataforma para que los clientes puedan navegar por los productos, agregarlos al carrito de compras y realizar pedidos. Seguidamente mostraremos como llevamos a cabo la modernizacion y despliegue de la arquitectura e infraestructura de la aplicacion, automatizandola de forma tal que mediante el comando de Terraform "terraform apply" se pueda desplegar.
## Dinamica de Trabajo:
Primeramente comenzamos con la creacion de un repositorio publico en GIT, excusivo para este trabajo. Una vez los integrandes del equipo clonan el repo, lo sincronizamos con Visual Studio code y comenzamos a trabajar:

El proyecto lo vamos a dividir en 3 etapas:
 - Creacion de Infraestructura mediante Terraform
 - Script Automatizador 
 - Despliegue de Aplicacion

#### Creacion de Infraestructura

Comenzamos con la creacion de un VPC que tendra dos zonas de disponibilidad que me preoveeran la redundancia para la aplicacion. Estas ZA tendran sus respectivas subnets publicas asociadas a la tabla de ruteo por defecto que me brinda AWS al momento de crear el vpc, para finalmente salir a internet mediante un internet gateway.
Mediante un ALB (Aplication Load Balancer) podremos acceder a un Bastion, que tendra un script con el deploy de la aplicacion.

#### Script automatizador

Como mencionabamos anteriormente, nuestro script estara alojado en una instancia llamada bastion, que es el que basicamente se encargara de la construcccion de las imagenes mediante Docker y el despliegue de los contenedores mediante KubCtl.

En el mismo se puede apreciar primeramente la declaracion de Variables:
- ECR_ID: Esta variable me servira para obtener el URI del repo de ECR y me servira para pushear las imagenes una vez creadas.
- SRC_WORKDIR: Indicamos donde iran guardados los datos, damos permisos al usuario ec2 y permisos de carpeta necesarios para el buen funcionamiento del script. (Directirio se crea mediante un provisioner).
- MICROSERVICES: Esta es una lista con los nombres de los PODS.

Seguidamente pasamos a instalar Docker, Kubectl (actualizacionde de paquetes y demas se hacen mediante provisioners) y comenzamos a trabajar con nuestro primer bucle que recorrera la lista de PODS, contrsutruyendo, tagueando y pusheando las imagenes a la registry.

Acto seguido registramos Kubernetes contra nuestro clúster previamente creado en Terraform y volvemos a recorrer la lista antes mencionada, pero esta vez recorreremos los manifiestos de cada POD, reemplazando "IMAGE" por la URL de la imagen y "TAG" por "latest".

Finalmente haremos el despliegue recorriendo por ultima vez la lista MICROSERVICES y ejecutando Kubectl para cada POD.

#### Despliegue de Aplicacion

Como se menciona anteriormente, se ultiliza terraform como base para la construccion de una infra, esta tendra una instancia llamada bastion que contiene un script automatizador y que me permitira el despliegue de la misma.
Para ello, teniendo los requisitos necesarios para ejecutarla, bastara con hacer el comando:

- terraform apply -var-file=var.tfvars


## Diagrama de Arquitectura:

![Diagrama](https://github.com/maikool22/obligatorio-boutique/blob/main/docs/img/InfraCloud.drawio.png)
## Datos de Infraestructura:
aca van los tipos de instancia, bloques cidr, firewalling, etc
## Servicios de AWS usados:

|      Recurso   |Nombre                         |Archivo                      |
|----------------|-------------------------------|-----------------------------|
|ALB             |oblimanual-alb                 |alb.tf                       |
|ECR             |my_repositories                |ecr.tf                       |
|EKS CLUSTER     |oblimanual-kluster             |eks.tf                       |
|EKS NODE-GROUP  |oblimanual-kluster-ng          |eks.tf                       |
|EC2 INSTANCE    |bastion                        |instances.tf                 |
|VPC             |oblimanual-vpc                 |network.tf                   |
|PUBLIC SUBNET 1 |oblimanual-subnet1-publica     |network.tf                   |
|PUBLIC SUBNET 2 |oblimanual-subnet2-publica     |network.tf                   |
|INTERNET GATEWAY|oblimanual-ig                  |network.tf                   |
|ROUTE TABLE     |oblimanual-rt                  |network.tf                   |
|SECURITY GROUP  |oblimanual-sg                  |security.tf                  |


## Despliegue de la APP:
- Para poder realizar un correcto despliegue de la solucion, previamente habra que iniciar el ambiente de laboratorio y actualizar las credenciales
en el archivo ~/.aws/credentials asi como tambien descargar el archivo labsuser.pem, renombrarlo a vockey.pem, moverlo dentro de la carperta resources y cambiarle los permisos (chmod 400 vockey.pem).

- Otra cosa importante, tener en cuenta que en el archivo instances.tf en la linea 30 se encuentra el siguiente bloque de codigo que hay que modificar segun el usuario:

```terraform
  provisioner "file" {
    source      = "/home/damian/.aws/credentials"
    destination = "/home/ec2-user/.aws/credentials"
  }
  provisioner "file" {
    source      = "/home/damian/.aws/config"
    destination = "/home/ec2-user/.aws/config"
  }
```

Cambiando el source del archivo de credenciales y del config de la aws cli, esto es porque luego vamos a copiar dichos archivos dentro de la instancia bastion utilizando provisioner "file" para tal fin. 

## Requisitos para el Despliegue de la APP:
- Un pc con internet
- AWS cli 2.11.21
- Terraform 1.5.1
- Terraform provider aws 5.3.0
- Cuenta en aws (se utilizó la cuenta de estudiante)

## Pruebas de Funcionamiento:
[![asciicast](https://asciinema.org/a/XGVEeSSxRbjhWzcpJKe8Uuguf.svg)](https://asciinema.org/a/XGVEeSSxRbjhWzcpJKe8Uuguf)

fotos, pruebas y videos de la app funcionando
## Desafios encontrados:
- El poder separar el problema planteado en distintos problemas mas pequeños para resolver facilmente
- El manejo de las variables y como debiamos utilizarlas en nuestra solucion.
- Comprension basica de como funciona Docker y Kubernetes.
- La ami que oficia de bastion a menudo se quedaba corta de recursos para las tareas.
## Oportunidades de Mejora:
- Evitar lo mas posible la dependencia de provisioners
- Utilizar provider de Kubernets para la parte del build.
- Utilizar modulos, por falta de tiempo no se pudo implementar.
- 
## Declaracion de Autoria:
Por la siguiente, Maikool Rodriguez  y Damián Sandoval con números de estudiante 253225  y 205106 respectivamente, estudiantes de la carrera “Analista en Infraestructura Informática” en relación con el trabajo obligatorio de fin de semestre presentado para su evaluación y defensa, declaramos que asumimos la autoría de dicho documento entendida en el sentido de que no se han utilizado fuentes sin citarlas debidamente.

## Referencias:
- Documentacion de Terraform
- Documentacion de Kubernetes
- Documentacion de AWS
- Videos de clase

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@#%%%%%%%%&&&&&&%%%%%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@(##%%%%%%%%&&&&&&%%%%%#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@////##%%%%%%&&&&&&&%%%%#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@&((((###/###%%%%%%%%%%%%%#/%@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@**//(##(*,,. .../%#,,...,*/*/@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@%(*//(#%%%%%%%%%%&&%%*//,,//*@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@(%/*/#%%%%%%%(%%&&%#%%%%##*(@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@*,*(((###*#*..*,.*,#%##(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@(.,**/#(*,.,,,*,,,,,///*#@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@..,**//,(,,(@@&#..,#/*,%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ..,,/##(###(###(***.&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@* . ..,/%%#%####(...@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ .    ...,,,,,. &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#     . ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```
