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
  ![resolv.conf Debian1 Álvaro](imagenes/alvaro/resolvdebian1.jpg)<br><br>
  
La DMZ, es decir, los equipos que tiene a Debian5 como servidor DNS preferido, está representada por Debian3-Pruebas y la MZ, es decir, los equipos que tiene a Debian6 como servidor DNS preferido, está representada por Debian2-Pruebas. Esta configuración se hará mediante DHCP, aprendido en la unidad anterior, para ello editaremos el fichero /etc/dhcp/dhcpd.conf en el Debian1:
- Debian1-Pruebas:
  - Fran:<br>
  ![dhcpd.conf Debian1 Fran](imagenes/francisco/dhcpd.conf-Debian1.png)
  - Guillermo:<br>
   ![dhcpd.conf Debian1 guillermo](imagenes/guillermo/dhcpd.conf.png)
  - Álvaro:<br>
  ![dhcpd.con Debian1 Álvaro]()<br><br>
  
Como vemos, reservamos una IP al Debian2 y al Debian3 y ponemos como servidor DNS preferido y alternativo el que corresponda según sea la MZ o la DMZ. El range empieza en .103 y .104 debido a que si lo empezamos en 100 o en algun rango que incluya las IPs que hemos reservado, nos dará un error. Una vez configurado todo esto, obtendremos la siguiente configuración en los clientes:
- Debian2-Pruebas:
  - Fran:<br>
  ![resolv.conf Debian2 Fran](imagenes/francisco/resolv.conf-Debian2.png)
  - Guillermo:<br>
   ![resolv.conf Debian2 guillermo](imagenes/guillermo/resolv.confdeb2.png)
  - Álvaro:<br>
  ![resolv.conf Debian2 Álvaro]()<br><br>
  
- Debian3-Pruebas:
  - Fran:<br>
  ![resolv.conf Debian3 Fran](imagenes/francisco/resolv.conf-Debian3.png)
  - Guillermo:<br>
   ![resolv.conf Debian3 guillermo](imagenes/guillermo/resolv.confdeb3.png)
  - Álvaro:<br>
  ![resolv.conf Debian3 Álvaro]()<br><br>
  
  ---
8. **Registros especiales** <br>
Los registros especiales que nosotros vamos a poner son NS, CNAME, MX y SOA. Para estos registros solo vamos a subir una captura, ya que se pueden ver por separado en capturas anteriores.<br>

- Registros NS: Representa a los servidores DNS del espacio de nombres, en nuestro caso son el Debian5-pruebas y Debian6-pruebas.<br>
 ![Registro NS](imagenes/registrosNS.png)<br><br><br>
- Registros CNAME: Se usa para añadir alias a ciertos equipos equipos y que sean accesibles por varios nombres, por ejemplo nuestro router será accedido mediante Debian1-pruebas.routers.producción.com o cambiando el último nivel por enrutador.<br>
 ![Registro cname debian1](imagenes/cname-Debian1.png)<br><br>
 ![Registro cname debian3](imagenes/cname-Debian3.png)<br><br>
 ![Registro cname debian5 y 6](/imagenes/cname-Debian5%20y%20Debian6.png)<br><br><br>

- Registros MX: Se usa para reconocer rápidamente los servidores de correo del dominio, que en nuestro caso será Debian3-pruebas.<br>
![Registro mx](imagenes/mx-Debian3.png)<br><br><br>

- Registros SOA: Define algunas caracterísiticas de cada zona que describiré a continuación, además debe ser el primer resgistro de cada zona. Este es nuestro registro del servidores.produccion.com:<br>
![Registro SOA](imagenes/RegistroSOA.png)<br><br>
  - Servidores.produccion.com: Es basicamente el nombre del dominio e ira cambiando según donde nos encontremos, en db.equipos sería equipos.produccion.com, auqnue también se puede sustituir por un @ que representa basicamente la directiva @ORIGIN.<br>
  
  - Debian5: Se trata del servidor DNS primario de la zona.<br>
 
  - admin: se trata de la dirección de correo eléctronico de la persona responsable de la zona.<br>
  
  - Serial: Es la versión del archivo, si aumenta es que el archivo ha cambiado, hemos elegido el número 7 para ir aumentándolo de 7 en 7, ya que pensamos que se diferencia mucho mejor que de uno en uno.<br>
  
  - Refresh: Es el tiempo que se da entre cada vez que los servidores secundarios verifican si ha habido algún cambio en los primarios para hacer la transferencia de zona. En nuestro caso es de 7 días, ya que somos una empresa en asentada y no solemos tener necesidad de introducir resgistros nuevos.
  
  - Retry: Es el tiempo que tarda el servidor secundario en volver a intentar una transferencia fallida. En nuestro caso es de un día, puede parecer bastante tiempo pero realmente se debe dejar un tiempo primordial que nos permita solucionar el problema.<br>
   
  - Expire: Es el tiempo que durarán las peticiones del servidor esclavo al primario, mientras este no responda. En nuestro caso es de un mes, un tiempo bastante largo, porque no comtemplamos que el servidor primario no responda, si eso pasa, algo va mal.<br>
  
  - Negative Cache TTL: Tiempo que otros servidores guardan en caché la zona. En nuestro caso es de siete días para que tengan bastante tiempo ese extra de velocidad.

---
9. **Transferencias de zonas**<br>
En este proyecto haremos transferencias de zona desde el Debian6 al Debian5, aunque en la ssolución real se tendría que hacer en ambos sentidos. Para empezar, en el fichero /etc/bind/named.conf.local, cuando definamos las zonas, tendremos zona masters y zonas esclavas. en estas zonas esclavas habrá que esspecificar cual es la IP del servidor DNS master de esa zona, que será el cual nos haga las tranferencias de zona. También, dentro de esa zona debemos añadir "allow-notify", sirve para que cada vez que se cargue la zona, el equipo pregunte a la IP indicada sobre el serial del registro SOA, el cual si se cambia, se hará la transferencia de zona. A continuación las capturas:

  - Fran:<br>
  ![slave y notify Fran](imagenes/francisco/name.conf.local-Debian5-slave.png)
  - Guillermo:<br>
   ![slave y notify guillermo](imagenes/guillermo/notify.png)
  - Álvaro:<br>
  ![slave y notify Álvaro]()<br><br>
  
 También debemos tener activadas transferencias de zona en el Debian6, es decir, el cual las va a enviar.<br>
   - Fran:<br>
  ![allow-transfer Fran](imagenes/francisco/allow-transfer-Debian6.png)
   - Guillermo:<br>
   ![allow-transfer guillermo](imagenes/guillermo/notifyyes.png)
   - Álvaro:<br>
  ![allow-transfer Álvaro]()<br><br>

Una vez hecho todo esto, reiniciamos el servicio y al hacer _ls_ debemos tener el archivo esclavo.
   - Fran:<br>
  ![comprobación transferencia Fran](imagenes/francisco/transferencia%20de%20zona%20Debian5-Debian6.png)
   - Guillermo:<br>
   ![comprobación transferencia guillermo](imagenes/guillermo/comprobacionesclavo.png)
   - Álvaro:<br>
  ![comprobación transferencia Álvaro]()<br><br>
  
  ---
  10. **Comprobaciones**<br>
Es el momento de hacer las comprobaciones necesarias para ver que todo funciona:<br> 
- Comprobacion de un equipo del dominio:<br>
   - Fran:<br>
  ![comprobación dentro de red fran](imagenes/francisco/host-PC1-Debian2.png)
   - Guillermo:<br>
   ![comprobación dentro de red guillermo](imagenes/guillermo/hostpc1.png)
   - Álvaro:<br>
  ![comprobación dentro de red Álvaro]()<br><br>
  
- Comprobacion de los servidores de correo:<br>
   - Fran:<br>
  ![comprobación de servidores de correo fran](imagenes/francisco/host-MX-Debian2.png)
   - Guillermo:<br>
   ![comprobación de servidores de correo guillermo](imagenes/guillermo/hostmx.png)
   - Álvaro:<br>
  ![comprobación de servidores de  Álvaro]()<br><br>
  
- Comprobacion de los servidores de nombre:<br>
   - Fran:<br>
  ![comprobación de servidores de nombre fran](imagenes/francisco/host-NS-Debian2.png)
   - Guillermo:<br>
   ![comprobación de servidores de nombre guillermo](imagenes/guillermo/hostNS.png)
   - Álvaro:<br>
  ![comprobación de servidores de nombre Álvaro]()<br><br>
  
- Comprobacion de los registros Cname:<br>
   - Fran:<br>
  ![comprobación de cname fran](imagenes/francisco/host-CNAME-Debian2.png)
   - Guillermo:<br>
   ![comprobación de cname guillermo](imagenes/guillermo/hostcname.png)
   - Álvaro:<br>
  ![comprobación cname Álvaro]()<br><br>  
  
- Comprobacion de las zonas inversas:<br>
   - Fran:<br>
  ![comprobación de zona inversa fran](imagenes/francisco/host-Inverso-Debian2.png)
   - Guillermo:<br>
   ![comprobación de zona inversa guillermo](imagenes/guillermo/hostinverso.png)
   - Álvaro:<br>
  ![comprobación de zona inversa Álvaro]()<br><br>
  
- Comprobacion de resoluciones fuera del dominio:<br>
   - Fran:<br>
  ![comprobación fuera](imagenes/francisco/host-Google-Debian2.png)
   - Guillermo:<br>
   ![comprobación fuera](imagenes/guillermo/hostgoogle.png)
   - Álvaro:<br>
  ![comprobación fuera]()<br><br>
