![caratula](https://user-images.githubusercontent.com/88108014/175550159-21bfc6ce-abe4-4990-8604-576c61fbfcdb.png)

![Continuous Integration](https://github.com/GoogleCloudPlatform/microservices-demo/workflows/Continuous%20Integration%20-%20Main/Release/badge.svg)

## Presentación del problema

_La empresa “e-shop Services” nos ha contratado para desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise_

## Resumen de la solución ☁️

La solución fue montar una infraestructura en AWS con nuevas capacidades tecnológicas y de innovación, teniendo mayor agilidad en la operación, ambientes bajo demanda y capacidad de innovación, así como nuevas funcionalidades sin altos niveles de inversión.

Para que su servicio de e-commerce pueda expandirse por todo el mundo y se adapte mejor con la arquitectura de microservicios realizaremos la migración de estas cargas de trabajo a través de arquitecturas de hardware a la nube de a AWS 
utilizando una Infraestructura como servicio en la cual trabajaremos con docker y kubernetes teniendo así una alta disponibilidad mediante grupos de auto escalamiento, Elastic Load Balancer, desacoplamiento de almacenamiento persistente y de alto desempeño.

Creamos una instancia EC2 la cual será el equipo bastión y se configura el bloque userdata para que se instalen todos los componentes que vamos a utilizar para el despliegue.

El equipo de desarrollo que implemento Online Boutique basandose en una arquitectura de microservicios para que corra sobre containers nos proporciono el repositorio donde se encuentra alojado: https://github.com/ISC-ORT-FI/online-boutique
Al mismo tendremos que realizarle algunas modificaciones para poder desplegar sin problema en nuestra infrastructura.
Se realiza el buildeo de todos los microservicios que necesitamos para que la web funcione correctamente y se modifican los deployment.

- Arquitectura Micro-servicios ![on](https://user-images.githubusercontent.com/88108014/175647055-9ca163b9-8082-4c93-be92-5bfdd6060eb7.png)

![MICRO](https://user-images.githubusercontent.com/88108014/175645251-bcdcccc4-185e-49f7-88cc-06be6a5c5f31.png)

