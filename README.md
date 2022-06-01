## ![Captura](https://user-images.githubusercontent.com/88108014/171061048-dc628b45-1269-4cb8-b5ed-6595bcc5a508.PNG)
##

1. Presentación del problema

La startup “e-shop Services” ha recibido una ronda de inversión para expandir sus operaciones por todo el mundo, haciendo llegar sus servicios de e-commerce y retail, a todo el continente de América. La competencia actualmente está posicionada en la región a la cual se quiere expandir, pero los inversionistas están presionando para que “e-shop Services” expanda su marca ya que de esto depende el seguir invirtiendo. 


Se ha contratado a la consultora BitBeat para modernizar y desplegar la arquitectura e infraestructura de su aplicación que actualmente corre en un datacenter on-premise. Una célula de desarrollo trabajó en la implementación del e-commerce basado en una arquitectura de microservicios para correr sobre containers cuyo ciclo de integración continua ya se encuentra configurado y la solución ya se encuentra disponible para desplegar por parte del equipo de DevOps.

2. Arquitectura Legacy (Monolito)

2.1. Descripción de la Arquitectura

3. Arquitectura Actual (Micro-servicios)

4. Entrega
En un repositorio de Git:
- Código de la infraestructura automatizada
- Documentar en formato Markdown detalles de la implementación, cómo lo son:
- diagrama de arquitectura completo
- datos de la infraestructura (tipo de instancia, bloques CIDRs, Firewalling, etc)
- servicios de AWS usados
- etc

Despliegue / Implementación:
- Implementación de la solución en AWS Academy
- Presentación a modo de venta del trabajo para la defensa
Algunas consideraciones / aclaraciones
1. Se valorará cuantitativamente el nivel de automatización (bajo / medio / alto)
2. Se proveerá un template para la presentación para la defensa.
3. Se espera el diagrama de arquitectura con las fuentes e iconografía típicos de un
diagrama de AWS. Se recomienda usar draw.io que contiene los templates necesarios
para este tipo de diagrama. El mismo deberá incluir el networking a implementar.





_Obligatorio 2022_
_Fecha de entrega 28/06/2022_

###Pruebas 

1. crear una EC2
2. Instalar docker y docker-compose && git
3. Clonar el repo del obligatorio
4. Generar un docker-compose.yml que genere todas las imagenes de los Dockerfiles
5. Correr ya sea con docker swarm o con docker run nomas cada contenedor
