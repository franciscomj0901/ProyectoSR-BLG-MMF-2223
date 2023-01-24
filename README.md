
# Implantación del servicio DNS en el entorno de trabajo
#### SER - Guillermo Bárcena López, Francisco Mejías de Matos y Alvaro Jimenez talaverón <br>
![Foto de la portada](imagenes/download%20(6).jpeg)
---
Este es un proyecto el cuál hemos realizado con el fin de poner en práctica todo lo aprendido sobrer DNS y resolucion de nombres. Para explicarlo utilizaremos el guión proporcionado por nuestro profesor Jose Luis Rodríguez.

---
1. **Figura con la infraestructura del entorno** <br>
La infraestructura que hemos desarrollado ha sido la siguiente:<br>
![Infraestructura](imagenes/DiagramaProyectoDNS.png)
[Enlace al diagrama](https://drive.google.com/file/d/1OGA-V4_20N8UnIGlXNveywVdCZCEsaSm/view?usp=sharing)<br>
Como podemos ver en la imagen el escenario esta dividido en 2 redes, la DMZ con 4 equipos, y la MZ con 5 y los dos servidores DNS, a todo esto se le suma un router que interconecta las dos redes y les da salida a internet a través de una red NAT. El direccionamiento se hará intercalando el método estático que lo utilizarán Debian5-pruebas, Debian6-pruebas y Debian1-pruebas, y los demás equipos obtendrán su configuración mediante DHCP.<br>
La DMZ y Debian1-pruebas tendrá como servidor DNS favorito a Debian5 y como secundario a Debian6-pruebas, por otro lado la MZ lo tendrá al contrario. <br>
Los servidores DNS tendrán de reenviador al Debian1-pruebas que resolverá los nombres de fuera de nuestra red accediendo a los Servidores DNS root.
---
2. **Tener Instalado el servicio DNS en Debian5-pruebas y en Debian6-pruebas** <br>
Lo debemos tener instalado en los dos equipos para dividir la resolución de nombres por igual y repartirse el trabajo entre los dos, además nos proporciona una resistencia mayor a los fallos, ya que, si falla un servidor estará el otro para suplirlo.<br>
Esto se puede comprobar mediante el comando "sudo service bind9 status" y debería salirnos este resultado.
![status](imagenes/status.PNG)
---
3. **Espacio de nombres** <br>
Este es nuestro espacio de nombres que explicaremos a continuación:<br>
![Espacio de nombres](imagenes/espacionombres.PNG)<br>
[Enlace al diagrama](https://drive.google.com/file/d/1t0toJ2aAeeb92nNTWth2CG8ceuFkpZOH/view?usp=sharing)<br>
Todas las máquinas virtuales de las que disponemos, es decir las DebianX-pruebas estan dotadas de su correspondiente nombre, además de las maquinas adicionales para completar la red. Los equipos de cada zona no han sido colocados al azar, ya que tienen influencia en el balanceo de carga del que hablaremos en el punto 7. <br>
Llegamos, y superamos los dominios hasta tercer nivel en la zona c, donde un ejemplo sería: ("PC1.almacen.equipos.produccion.com). <br>
Hablando de que hemos puesto en cada zona:
- En la zona A (Servidores), basicamente se encuentran todos los servidores, excepto los DNS.
- En la zona B (Routers), hemos colocado los routers de los que disponemos.
- En la zona C (Equipos), hemos colocado todos los equipos y los servidores DNS. Está dividida en 3 apartados:
  - Almacen: PC1 y Debian2-Pruebas formarán parte de él.
  - Finanzas: PC3, PC4, PC5 perrtenecerán a este subgrupo.
  - Servidoresdns: Contendrá a Debian5-Pruebas Debian6-Pruebas.
---
4. **Zonas directas** <br>
En las zonas directas Debian5-pruebas será el servidor principal para las zonas A y B y secundario para C, contrariamente, Debian6-pruebas será el servidor secundario para las zonas A y B y principal Para la zona C.<br>
Además debemos acordarnos de colocar la línea de las notificaciones en las zonas secundarias<br>
A continuación, vamos a dejar las capturas del archivo /etc/bind/named.conf.local de cada uno de nosotros.<br>
- Debian5-Pruebas:
  - Fran:<br>
  ![conf.local Debian5 Fran](imagenes/francisco/name.conf.local-Actividad%204%20Debian5.png)
  - Guillermo:<br>
   ![conf.local Debian5 guillermo](imagenes/guillermo/named.conf.local.ej4.PNG)
  - Álvaro:<br>
  ![conf.local Debian5 Álvaro](imagenes/alvaro/named.conf.localalvaro.jpg)
  
- Debian6-Pruebas:
  - Fran:<br>
  ![conf.local Debian6 Fran](imagenes/francisco/name.conf.local-Actividad%204%20Debian6.png)
  - Guillermo:<br>
   ![conf.local Debian6 guillermo](imagenes/guillermo/named.conf.local.ej4(2).PNG)
  - Álvaro:<br>
  ![conf.local Debian6 Alvaro](imagenes/alvaro/named.conf.locald6alvaro.jpg)

Una vez que ya tenemos estos archivos creados hay que configurar los archivos db.xxxxxx<br>
- dbservidores (Que se encuentra en el Debian5.pruebas)<br>
  - Fran:<br>
   ![db.servidores Fran](imagenes/francisco/db.servidores.com%20Debian5.png)
  - Guillermo:<br>
   ![db.servidores Guillermo](imagenes/guillermo/db.servidores.PNG)
  - Álvaro:<br>
![db.servidores Alvaro](imagenes/alvaro/db.servidores.comalvaro.jpg)
- db.routers (Que se encuentra en el Debian5-pruebas)<br>
  - Fran:<br>
   ![db.routers francisco](imagenes/francisco/db.routers.com%20Debian5.png)
  - Guillermo:<br>
  ![db.routers francisco](/imagenes/guillermo/db.routers.PNG)
  - Álvaro:<br>
![db.routers alvaro](imagenes/alvaro/db.routers.comalvaro.jpg)<br><br><br>
- db.equipos (Que se encuentra en el Debian6-pruebas)<br>
  - Fran:<br>
   ![db.equipos francisco](imagenes/francisco/db.equipo.com%20Debian6.png)
  - Guillermo:<br>
  ![db.equipos guillermo](imagenes/guillermo/db.equipos.PNG)
  - Álvaro: <br>
 ![db.equipos alvaro](imagenes/alvaro/db.equipos.comalvaro.jpg)
 ---
 5. **Zonas inversas** <br>
Las zonas inversas actúan al contrario que las zonas directas, es decir nos entregan el nombre dns a partir de la dirección IP. A continuación os dejaremos fotos de las actualizaciones que hemos realizado en el archivo /etc/bind/named.conf.local:

- Debian5-Pruebas:
  - Fran:<br>
  ![conf.local inversas Debian5 Fran](imagenes/francisco/name.conf.local-ZonasInversas-Debian5.png)
  - Guillermo:<br>
   ![conf.local inversas Debian5 guillermo](imagenes/guillermo/zonasinversasdeb5.PNG)
  - Álvaro:<br>
  ![conf.local inversas Debian5 alvaro](imagenes/alvaro/debian5namedconfnuevoalvaro.png)<br><br><br>
  
- Debian6-Pruebas:
  - Fran:<br>
  ![conf.local inversas Debian6 Fran](imagenes/francisco/name.conf.local-ZonasInversas-Debian6.png)
  - Guillermo:<br>
   ![conf.local inversas Debian6 guillermo](imagenes/guillermo/zonasinversasdeb6.PNG)
  - Álvaro:<br>
  ![conf.local inversas Debian6](imagenes/alvaro/debian6namedconfnuevoalvaro.png)<br><br><br>

Una vez que ya tenemos estos archivos creados hay que configurar los archivos db.MZ y db.DMZ<br>
- db.DMZ (Que se encuentra en el Debian5.pruebas)<br>
  - Fran:<br>
   ![db.DMZ Fran](imagenes/francisco/db.DMZ-Debian5.png)
  - Guillermo:<br>
   ![db.DMZ Guillermo](imagenes/guillermo/db.DMZ.PNG)
  - Álvaro:<br>
![db.DMZ alvaro](imagenes/alvaro/dbDMZdebian5alvaro.png)<br><br><br>
- db.MZ (Que se encuentra en el Debian6-pruebas)<br>
  - Fran:<br>
   ![db.MZ francisco](imagenes/francisco/db.MZ-Debian6.png)
  - Guillermo:<br>
  ![db.MZ francisco](imagenes/guillermo/db.MZ.PNG)
  - Álvaro:<br>
![db.MZ alvaro](imagenes/alvaro/dbMZdebian6alvaro.png)<br><br><br>

---
6. **Servidor DNS de solo caché** <br>

Ahora mismo nuestra red no resuelve nombres fuera de nuestro dominio, es decir si nosotros hicieramos "host www.google.es", es completamente imposible que nos resuelva. La mejor manera de arreglar esto es configurando un servidor DNS de solo caché, que en nuestro caso será el Debian1-pruebas. Este servidor realizará las resoluciones que Debian5-pruebas y Debian6-pruebas no puedan.<br>
Para poder hacer esto lo primero que habrá que hacer, logicamente, será descargarnos el servicio bind9 en Debian1-pruebas, y al contrario de lo que mucha gente piensa no configuraremos nada, porque sin tocar nada el primer archivo donde va a mirar es el que contiene los servidores DNS raiz y podrá resolver los nombres fuera de su red.<br>

Lo que sí que tenemos que configurar son los reenviadores del Debian6-pruebas y Debian5-pruebas que se configuran en el fichero /etc/bind/named.conf.options, A continuación se muestran las capturas: <br>
- Debian5-Pruebas:
  - Fran:<br>
  ![reenviadores Debian5 Fran](imagenes/francisco/forwarders-Debian5.png)
  - Guillermo:<br>
   ![Reenviadores Debian5 guillermo](imagenes/guillermo/Forwarders.PNG)
  - Álvaro:<br>
  ![Reenviadores Debian5 Álvaro](imagenes/alvaro/forwardersdebian5.jpg)
  
- Debian6-Pruebas:
  - Fran:<br>
  ![Reenviadores Debian6 francisco](imagenes/francisco/forwarders-Debian6.png)
  - Guillermo:<br>
   ![Reenviadores Debian6 guillermo](imagenes/guillermo/forwarders2.PNG)
  - Álvaro:<br>
  ![Reenviadores Debian6 Álvaro](imagenes/alvaro/forwardersdebian6.jpg)

---
7. **Resolución DNS en los clientes** <br>
En este apartado explicaremos el balanceo de carga que hemos realizado, es decir, la mitad de equipos tendrán como servidor DNS preferido al Debian5 y como alternativo al Debian6 y la otra mitad justo al contrario, de esta forma conseguimos que la red este balanceada y ambos servidores reciban la misma carga y así no se saturen.
- Equipos que tendrán a Debian5 como preferido y a Debian6 como alternativo: Debian1, PC8, PC9, PC10, Debian3.
- Equipos que tendrán a Debian6 como preferido y a Debian5 como alternativo: PC1, Debian2, PC3, PC4, PC5. <br><br>
Así mismo, Debian5 y Debian6 se tendrán como preferido a ellos mismos y como alternativo al otro. A continuación pondremos captura de pantalla del fichero /etc/resolv.conf de cada uno de ellos, en este fichero se configura los servidores DNS en orden de preferencia.

- Debian5-Pruebas:
  - Fran:<br>
  ![resolv.conf Debian5 Fran](imagenes/francisco/resolv.conf-Debian5.png)
  - Guillermo:<br>
   ![resolv.conf Debian5 guillermo](imagenes/guillermo/resolv.confdeb5.PNG)
  - Álvaro:<br>
  ![resolv.conf Debian5 Álvaro](imagenes/alvaro/resolvdebian5.jpg)
  
- Debian6-Pruebas:
  - Fran:<br>
  ![resolv.conf Debian6 francisco](imagenes/francisco/resolv.conf-Debian6.png)
  - Guillermo:<br>
   ![resolv.conf Debian6 guillermo](imagenes/guillermo/resolv.confdeb6.PNG)
  - Álvaro:<br>
  ![resolv.conf Debian6 Álvaro](imagenes/alvaro/resolvdebian6.jpg)<br><br>
  
Debian 1 tendrá su configuración estática así que su resolv.conf se configurará de forma manual, y como ya hemos dicho antes, tendrá al Debian5 como preferido y al Debian6 como alternativo. A continuación se muestra una foto de cada uno de nuestros ficheros:
- Debian1-Pruebas:
  - Fran:<br>
  ![resolv.conf Debian1 Fran](imagenes/francisco/resolv.conf-Debian1.png)
  - Guillermo:<br>
   ![resolv.conf Debian1 guillermo](imagenes/guillermo/resolv.confdeb1.PNG)
  - Álvaro:<br>
  ![resolv.conf Debian1 Álvaro](imagenes/alvaro/resolvdebian1.jpg)
