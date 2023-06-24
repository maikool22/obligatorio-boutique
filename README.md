
<h1 align="center"> BOUTIQUE ONLINE </h1>

---
## Descripcion del Problema:
La startup "e-shop Services" ha recibido una ronda de inversión para expandir sus operaciones por todo el mundo, haciendo llegar sus servicios de e-commerce y retail, a todo el continente de América.La competencia actualmente está posicionada en la región a la cual se quiere expandir, pero los inversionistas están presionado para que  "e-shop Services" expanda su marca ya que de esto depende seguir invirtiendo.Se ha contratado a la consultora BitBeat para modernizar y desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise.Una célula de desarrollo trabajó en la implementación del e-commerce basado en una arquitectura de microservicios para correr sobre containers cuyo ciclo de integración continua ya que se encuentra configurado y la solución ya se encuentra disponible para desplegar por parte del equipo de DevOps.

[![asciicast](https://asciinema.org/a/k5l1Aa7sODNu5j4LItb3j7Kj2.svg)](https://asciinema.org/a/k5l1Aa7sODNu5j4LItb3j7Kj2)

## Descripción de la Solucion:
El proyecto de la Tienda Online es un sistema de comercio electrónico que permite a los usuarios comprar productos en línea. Proporciona una plataforma para que los clientes puedan navegar por los productos, agregarlos al carrito de compras y realizar pedidos.

## Dinamica de Trabajo:
Se divide el proyecto en 3 etapas:
 - Creacion de Infraestructura
 - Construccion de Imagenes
 - Despliegue de Containers

#### Creacion de Infraestructura
Comenzamos con la creacion de un VPC que tendra dos zonas de disponibilidad que me preoveeran la redundancia para la aplicacion. Estas ZA tendran sus respectivas subnets publicas asociadas a la tabla de ruteo or defecto que me brinda AWS al momento de crear el vpc, para finalmente salir a internet mediante un internet gateway.
Mediante un ALB (Aplication Load Balancer) podremos acceder a un Bastion, que tendra un script con el deploy de la aplicacion.

#### Construccion de Imagenes

#### Despliegue de (no me la Container)

## Diagrama de Arquitectura:
ac va el dibujo en drowio
## Datos de Infraestructura:
aca van los tipos de instancia, bloques cidr, firewalling, etc
## Servicios de AWS usados:
- ec2 
- eks 
- ecr
- N I C K niki niki niki jam
## Despliegue de la APP:
aqui hablamos de como construimos las imagenes con docker y como las abarajamos y desplegamos con kubernetes.
vaya uno a saber como
## Requisitos para el Despliegue de la APP:
- cli aws
- la cuenta que tenemos para aws
- un pc
## Pruebas de Funcionamiento:
fotos, pruebas y videos de la app funcionando
## Dificultades:
- maikool
- entre otras lo de las instancias y como influye los recursos de estas al momento de buildear y demas 
- las dificultades con docker y kuernetes
## Oportunidades de Mejora:
- la automatizacion total mediante terraform
- etc
- etc
## Declaracion de Autoria:
Por la siguiente, Maikool Rodriguez  y Damián Sandoval con números de estudiante 253225  y 205106 respectivamente, estudiantes de la carrera “Analista en Infraestructura Informática” en relación con el trabajo obligatorio de fin de semestre presentado para su evaluación y defensa, declaramos que asumimos la autoría de dicho documento entendida en el sentido de que no se han utilizado fuentes sin citarlas debidamente.

## Referencias:
el mauri


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
