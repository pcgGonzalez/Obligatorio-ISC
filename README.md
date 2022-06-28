![caratula](https://user-images.githubusercontent.com/88108014/175550159-21bfc6ce-abe4-4990-8604-576c61fbfcdb.png)

![Continuous Integration](https://github.com/GoogleCloudPlatform/microservices-demo/workflows/Continuous%20Integration%20-%20Main/Release/badge.svg)

## Presentación del problema

_La empresa “e-shop Services” nos ha contratado para desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise_

## Resumen de la solución ☁️

La solución realizada consiste en migrar a una infraestructura de microservicios la cual esta basada en AWS. 

### Las ventajas de utilizar este modelo son:

- Escalabilidad
- Implementación sencilla
- Código reutilizable
- Agilidad en cambios
- Aplicación independiente
- Menor riesgo

Para realizar el despliegue correspondiente, se utilizará IaC mediante Terraform y cada microservicio será ejecutado en un contenedor que es orquestado por Kubernetes. Este último será levantado en EKS.
Las imágenes de docker que servirán de base para el despliegue serán alojadas en ECR para su disponibilidad.
Para lograr automatizar el despliegue, Terraform creará la infraestructura necesaria como Vpc, Route Table, Internet Gateway y Subnets así como el cluster de EKS para luego levantar una instancia EC2 que oficiará de “pivot”.
Dicha instancia ejecutará un script que instalará awscli, kubectl y descargará los manifiestos de Kubernetes para luego ejecutarlos en el cluster creado por Terraform.

El equipo de desarrollo que implemento Online Boutique basandose en una arquitectura de microservicios para que corra sobre containers nos proporciono el repositorio donde se encuentra alojado:[repositorio](https://github.com/ISC-ORT-FI/online-boutique)
Al mismo tendremos que realizarle algunas modificaciones para poder desplegar sin problema en nuestra infrastructura.
Se realiza el buildeo de todos los microservicios que necesitamos para que la web funcione correctamente y se modifican los deployment.

- Arquitectura Micro-servicios 
  ![on](https://user-images.githubusercontent.com/88108014/175647055-9ca163b9-8082-4c93-be92-5bfdd6060eb7.png)

![MICRO](https://user-images.githubusercontent.com/88108014/175645251-bcdcccc4-185e-49f7-88cc-06be6a5c5f31.png)

### Equipo Devops :gear:
Al momento de comenzar a trabajar con el despliegue de la infrastructura lo primero que se realiza es un repositorio en github donde todo el equipo devops va tener los permisos necesarios para poder implementar sus cambios y trabajar en conjunto en forma actualizada. 
Repositorio en el cual se trabaja:[aqui](https://github.com/pcgGonzalez/Obligatorio-ISC)

*Para poder ejecutar el código se necesita:* :pushpin:
* Ejecutarlo en pc o VM basado en Linux
* Tener instalado Terraform
* Cuenta de AWS
* AWS CLI
* Cuenta en Dockerhub
* Cuenta en Github
* Archivo .pem descargado localmente

*Se deben pasar las credenciales de las cuentas (AWS CLI, Github y Dockerhub) para que la instancia EC2 pueda realizar la conexión y ejecutar el script correctamente.*

### Variables 

1. aws_access_key_id - el ID que provee el lab de aws
2. aws_secret_access_key - la clave que provee el lab de aws
3. aws_session_token - el token que provee el lab de aws
4. aws_region - región en la cual se desplegarán los recursos
5. aws_account - Número de ID de la cuenta de AWS (es único e inmutable)
6. git_user - Usuario de Github
7. git_passsword - Clave del usuario en GitHub (acá seguramente pida el token de github para autenticarse)
8. docker_user - Usuario en DockerHub
9. docker_pwd - Clave del usuario de DockerHub
10. key - el nombre de la key (ya generada en AWS, por ejemplo vockey)
11. key_location - la ubicación del archivo .pem por ejemplo vockey.pem debe estar en el equipo desde donde se correrá el terraform apply y aclarar el  directorio en esta variable

### Files 

El repositorio consta de los siguientes files:
* [Cluster EKS](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/cluster_eks.tf): Realiza el despliegue del cluster EKS, los workernodes y se asocia con las subnet y el rol IAM a utilizarse. Debido a que fue desplegado en un ambiente AWS Academy, el rol a utilizar debe ser "LabRole".
* [ec2](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/ec2.tf): Despliega la instancia "pivot". Está basado en una AMI de Debian y su principal rol es el de ejecutar el script "start_script" así como alojar las variables que permitirán el correcto funcionamiento de dicho script. Para utilizarlo es necesario contar con el archivo .pem que permita conectarse vía ssh a la instancia, ya que utiliza provisioners como "remote-exec", por lo tanto debe especificarse la ruta de dicho archivo en el código, esto se realiza en el archivo terraform.tfvars, ya que se pasa como variable.
* [ecr](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/ecr.tf): Levanta el servicio de ECR donde serán alojadas las imágenes para el despliegue con Kubernetes.
* [provider.tf](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/provider.tf): En este file se definen variables tales como las correspondientes a las credenciales de AWS CLI, el provider en sí utilizado por Terraform (Terraform init) y los outputs que se vereán al terminar el despliegue de Terraform.
* [sg.tf](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/sg.tf): Se definen dos security gropus, uno para la instancia EC2, para que permita la conexión SSH necesaria para el despliegue via remote-exec, y otra para los microservicios.
* [start_script](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/start_script.sh): Este script sera alojado en la instancia EC2 que oficia de "pivot". El fin de este script es instalar el software necesario para bajarse el repositorio de git con los manifiestos de Kubernetes, crear las imágenes de Docker, agregar la imagen y tag a los manifiestos de Kubernetes, pushearlas a ECR, y desplegar los pods en EKS basándose en los manifiestos modificados. 
* [terraform.tfvars](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/terraform.tfvars): Aquí se definen las variables de loguin a AWS, a git, a Dockerhub y la ruta del archivo .pem.

Por lo tanto, en resumen se crearan los componentes de AWS: :hammer_and_wrench:
- [VPC](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/vpc.tf)
- [Internet Gateway](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/vpc.tf) 
- [Subnets](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/vpc.tf)
- [Route-Table](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/vpc.tf)
- [Security Group](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/sg.tf)
- [Pivot-sg](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/sg.tf)
- [Microservices-sg](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/sg.tf)

Se crean los componentes de Kubernetes/Docker:
- [eks-cluster](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/cluster_eks.tf)
- [workernodes](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/cluster_eks.tf)
- [ECR](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/ecr.tf) 


Cuando se termina de crear el cluster eks y los workersnodes se comienza con el despliegue de la instancia:
- Se le pasa el archivo [start_script.sh](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/aortega/start_script.sh)
- Se le cargan las variables de entorno a la instancia con el provisioner remote_exec
- Luego se le da permisos de ejecución al archivo start_script.sh

Se ejecuta el script.sh para aprovisionar la instancia y poder tener todo lo necesario para desplegar Online-Boutique:

El veneficio de hacer todo desde una instancia de EC2 para construir las imágenes y subirlas además se agregar una capa de seguridad ya que va a quedar como pivot server para poder administrar el Cluster, no tenemos la necesidad de especificar ningún tipo de requisitos de versiones de Terraform, Docker o lo que sea para poder correr nuestro código, sino que la misma instancia se va a encargar que se cumpla con todos los requisitos necesario para el buen funcionamiento del despliegue y que la web funcione correctamente. 

### Lo que va a [instalar](https://github.com/pcgGonzalez/Obligatorio-ISC/blob/main/Documentaci%C3%B3n/instalaciones.md) el script.sh: :pencil:

1. Hace un apt update
2. Instala git
3. Instala aws cli
4. Configura aws cli con los datos que le pasamos como variables
5. Instala Docker
6. Realizar el login en DockerHub y descargar la imagen de obligatorioisc/cartservice:v1 (Esto debido a que dicha imagen utiliza .net como motor y genera algunos conflictos si la imagen es construida en la instancia.
7. Se taggea la imagen descargada de DockerHub, se hace login a ECR para subirla al repo “online-boutique”.
8. Sube la imagen al repo en ECR
9. Se clona el repo de online-boutique del repositorio del profe github.com/ISC-ORT-FI/online-boutique.git
10. Se instala kubectl y lo asocia al Cluster que creamos "eks-cluster"
11. Despues corre una iteracción con un for que lo que hace es listar online-boutique/src y cargarlo a una variable, el for recorre cada uno de los microservicios listados ahi y ejecuta las siguientes acciones:
- Se mete al microservicio/deployment y reemplaza con un sed el nombre de la imagen que va a usar el deployment por el nombre que va a queda en el repo de ECR
- En la línea 6 le agrega una línea donde le especifica la cantidad de replicas, en este caso le dejamos 2 replicas.
- Construye la imagen del microservicio con el Dockerfile que está en online-boutique/src/microservicio taggeandola con el ID del ECR creado. (No va a construir "cartservice" porque tiene un directorio diferente ni "redis" ya que no tiene dockerfile)
- Hace un push de la imagen creada hacia el repo en ECR.
- Despliega los pods usando el manifesto del deployment ubicado en online-boutique/src/microservicio/deployment/kubernetes-manifests.yaml via kubectl.
Este listado de pasos lo va a hacer con cada uno de los micro servicios asi que le edita el manifesto del deployment, crea la imagen, la pushea a ECR y luego levanta el pod usando esa imagen

### Limitantes con AWS Educate:

Con la versión de AWS educate solo nos permite usar el rol "LabRole" en el Cluster EKS, tuvimos que generar una variable donde ingresamos el ID de cuenta de forma que se cambie en el código y complete el ARN donde debe ser definido. Aprovechando esta variable también la reutilizamos para obtener la URL del ECR. Si bien se podría haber hecho con el output de aws_ecr_repository.online-boutique.repository_url aprovechamos el uso de la otra variable para obtener este valor.

### Diagrama de la arquitectura desplegada:

![Diagramahtml drawio](https://user-images.githubusercontent.com/69149459/176176252-04e9abd0-d84a-4317-a738-08737cbd00ff.png)

![MicrosoftTeams-image](https://user-images.githubusercontent.com/88108014/176305434-c06b31bb-71d0-445a-8b15-be437f113c1f.png)


###  Prueba de funcionamiento de Online Boutique en la infraestructura: :clapper:

![prueb (1)](https://user-images.githubusercontent.com/88108014/176224270-3c63ac11-34ed-48a2-af7e-374db0eb125e.gif)
