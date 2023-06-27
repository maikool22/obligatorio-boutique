
<h1 align="center"> BOUTIQUE ONLINE </h1>

---
# Descripcion del Problema:

La startup "e-shop Services" ha recibido una ronda de inversión para expandir sus operaciones por todo el mundo, haciendo llegar sus servicios de e-commerce y retail, a todo el continente de América. La competencia actualmente está posicionada en la región a la cual se quiere expandir, pero los inversionistas están presionado para que "e-shop Services" expanda su marca ya que de esto depende seguir invirtiendo. Se ha contratado a la consultora BitBeat para modernizar y desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise. Una célula de desarrollo trabajó en la implementación del e-commerce basado en una arquitectura de microservicios para correr sobre containers cuyo ciclo de integración continua ya que se encuentra configurado y la solución ya se encuentra disponible para desplegar por parte del equipo de DevOps.

# Descripción de la Solucion:

El proyecto de la Tienda Online es un sistema de comercio electrónico que permite a los usuarios comprar productos en línea. Proporciona una plataforma para que los clientes puedan navegar por los productos, agregarlos al carrito de compras y realizar pedidos. A continuación mostraremos cómo llevamos a cabo la modernización y despliegue de la nueva arquitectura e infraestructura de la aplicación, automatizando de forma tal que mediante una herramienta de IAC (Infaestrectura como Código) tal como lo es Terraform se pueda desplegar facilmente la solución.

## Dinamica de Trabajo:

Comenzamos con la creación de un repositorio público en GIT exclusivo para este trabajo https://github.com/maikool22/obligatorio-boutique. Una vez los integrantes del equipo clonaron dicho repo. Se procede a configurar los ambientes con Visual Studio Code, se modifica el archivo .gitignore ya proporcionado por github, de forma de albergar los archivos que no se van a subir al repo (temoporales del SO, archivos .terraform y principalmente llaves públicas de AWS). Luego de esto se comienza a trabajar.

El proyecto lo vamos a dividir en 2 etapas:
 - Creación de Infraestructura mediante Terraform
 - Automatizacion del despliegue

#### Creacion de Infraestructura

Comenzamos con la creación de un VPC, el cual tendrá dos zonas de disponibilidad que nos proveerán la redundancia para la aplicación. Estas ZA tendrán sus respectivas subnets públicas asociadas a una tabla previamente creada, para finalmente salir a internet mediante un internet gateway.
Luego de esto se genera una instancia EC2 la cual va a servir de bastion para poder realizar el resto de las tareas para dejar el sitio funcionando.

#### Automatizacion del despliegue

Para tal fin se opta por crear un shell script el cual se encargara de:
 - Instalar dependencias y recursos extras necesarios para ejecutar Docker y Kubernetes en el bastion.
 - Realizar un build de cada uno de los servicios solicitados.
 - Taggear cada imagen y subirla con su correspondiente repositorio en ECS
 - Modificar cada manifiesto de kubernetes para coinicidir con la imagen publicada
 - Desplesgar los manifiestos de cada modulo mediante la CLI de Kubernetes.

Este script sera copiado y ejecutado mediante provisioners de terraform

Al principio se puede apreciar la declaración de Variables:
- ECR_ID: Esta variable nos servirá para obtener el URI del repo de ECR, para después pushear las imágenes una vez creadas.
- SRC_WORKDIR: Indicamos donde irán guardados los datos, damos permisos al usuario ec2 y permisos de carpeta necesarios para el buen funcionamiento del script. (Directorio se crea mediante un provisioner).
- MICROSERVICES: Esta es una lista con los nombres de los Servicios.

Seguidamente pasamos a instalar Docker, Kubectl (actualización de de paquetes y demás se hacen mediante provisioners) y comenzamos a trabajar con nuestro primer bucle que recorre la lista de servicios, contrsutruyendo, tagueando y pusheando las imágenes a la registry.

Acto seguido registramos Kubernetes contra nuestro clúster previamente creado en Terraform y volvemos a recorrer la lista antes mencionada, pero esta vez recorreremos los manifiestos de cada servicio, reemplazando "IMAGE" por la URL de la imagen y "TAG" por "latest".

Finalmente haremos el despliegue recorriendo por última vez la lista MICROSERVICES y ejecutando Kubectl para cada servicio.

## Diagrama de Arquitectura:

![Diagrama](https://github.com/maikool22/obligatorio-boutique/blob/main/docs/img/InfraCloud.drawio.png)

## Datos de Infra y Servicios de AWS usados:

|      Recurso   |Nombre                         |Archivo                      |Valor          |
|----------------|-------------------------------|-----------------------------|---------------|
|ALB             |oblimanual-alb                 |alb.tf                       |               |
|ECR             |my_repositories                |ecr.tf                       |               |
|EKS CLUSTER     |oblimanual-kluster             |eks.tf                       |               |
|EKS NODE-GROUP  |oblimanual-kluster-ng          |eks.tf                       |               |
|EC2 INSTANCE    |bastion                        |instances.tf                 |               |
|VPC             |oblimanual-vpc                 |network.tf                   |10.0.0.0/16    |
|PUBLIC SUBNET 1 |oblimanual-subnet1-publica     |network.tf                   |10.0.1.0/24    |
|PUBLIC SUBNET 2 |oblimanual-subnet2-publica     |network.tf                   |10.0.2.0/24    |
|INTERNET GATEWAY|oblimanual-ig                  |network.tf                   |               |
|ROUTE TABLE     |oblimanual-rt                  |network.tf                   |               |
|SECURITY GROUP  |oblimanual-sg                  |security.tf                  |               |


## Despliegue de la APP:

- Para poder realizar un correcto despliegue de la solución, previamente habrá que iniciar el ambiente de laboratorio y actualizar las credenciales
En el archivo ~/.aws/credentials asi como tambien descargar el archivo vockey.pem, moverlo dentro de la carpeta resources y cambiarle los permisos (chmod 400 vockey.pem).

- Otra cosa importante, tener en cuenta que en el archivo instances.tf en la linea 30 se encuentra el siguiente bloque de código que hay que modificar según el usuario:

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

Finalmente, una vez completados los pasos anteriores, aplicamos el comando:
``` bash terraform apply -var-file=var.tfvars```

## Requisitos para el Despliegue de la APP:
- Un pc con internet
- AWS cli 2.11.21
- Terraform 1.5.1
- Terraform provider aws 5.3.0
- Cuenta en aws (se utilizó la cuenta de estudiante)

## Pruebas de Funcionamiento:

**Compilacion del Programa:**
[![asciicast](https://asciinema.org/a/XGVEeSSxRbjhWzcpJKe8Uuguf.svg)](https://asciinema.org/a/XGVEeSSxRbjhWzcpJKe8Uuguf)

**Muestra de Funcionamiento:**

<a href="http://www.youtube.com/watch?feature=player_embedded&v=fCJZ-_2CRHY" target="_blank">
 <img src="http://img.youtube.com/vi/fCJZ-_2CRHY/mqdefault.jpg" alt="Prueba de Funcionamiento" width="480" height="240" border="10" />
</a>

## Desafios encontrados:

- El poder separar el problema planteado en distintos problemas más pequeños para resolver fácilmente
- El manejo de las variables y cómo debemos utilizarlas en nuestra solución.
- Comprensión básica de cómo funciona Docker y Kubernetes.
- La ami que oficia de bastion a menudo se quedaba corta de recursos para las tareas.
- Persistencia y sincronización de Redis en ambas zonas de disponibilidad.

## Oportunidades de Mejora:

- Evitar lo más posible la dependencia de provisioners
- Utilizar provider de Kubernetes para la parte del build.
- Tratar que el código sea más reciclable, utilizando módulos.
- Lograr la persistencia y sincronización del Redis utilizando volúmenes persistentes.
  
## Declaracion de Autoria:

Por la siguiente, Maikool Rodriguez  y Damián Sandoval con números de estudiante 253225  y 205106 respectivamente, estudiantes de la carrera “Analista en Infraestructura Informática” en relación con el trabajo obligatorio de fin de semestre presentado para su evaluación y defensa, declaramos que asumimos la autoría de dicho documento entendida en el sentido de que no se han utilizado fuentes sin citarlas debidamente.

## Referencias:

- Documentacion de Terraform
- Documentacion de Kubernetes
- Documentacion de AWS
- Videos de clase

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@&%%%%%%%%%%%@@@@@@@@@@@@@@
@@@@@@@@@%#%%%%%%%%%%%%%%%%%@@@@@@@@@@
@@@@@@@@#%%%%%%%%&&&&&&%%%%%#%@@@@@@@@
@@@@@@@(##%%%%%%%%&&&&&&%%%%%#(@@@@@@@
@@@@@@////##%%%%%%&&&&&&&%%%%#((@@@@@@
@@@@@&((((###/###%%%%%%%%%%%%%#/%@@@@@
@@@@**//(##(*,,. .../%#,,...,*/*/@@@@@
@@@@%(*//(#%%%%%%%%%%&&%%*//,,//*@@@@@
@@@@@(%/*/#%%%%%%%(%%&&%#%%%%##*(@@@@@
@@@@@@@*,*(((###*#*..*,.*,#%##(*@@@@@@
@@@@@@@(.,**/#(*,.,,,*,,,,,///*#@@@@@@
@@@@@@@@..,**//,(,,(@@&#..,#/*,%@@@@@@
@@@@@@@@@ ..,,/##(###(###(***.&@@@@@@@
@@@@@@@@@* . ..,/%%#%####(...@@@@@@@@@
@@@@@@@@@@@ .    ...,,,,,. &@@@@@@@@@@
@@@@@@@@@@@@@@#     . ,@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```
