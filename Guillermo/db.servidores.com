$TTL    604800
$ORIGIN servidores.produccion.com.
servidores.produccion.com.    IN      SOA       Debian5 admin(
                        7       ;Serial
                        604800  ;Refresh
                        86400   ;Retry
                        2419200 ;Expire
                        604800) ;Negative Cache TTL

;Servidores de nombre
@       IN      NS      Debian5.servidoresdns.equipos.produccion.com.
        IN      NS      Debian6.servidoresdns.equipos.produccion.com.
;Servidores de correo
        IN      MX      10      Debian3.servidores.produccion.com.

; Estaciones de trabajo
Debian3 1h      IN      A       172.17.4.103
servidorweb     IN      CNAME   Debian3
servidordecorreo        IN      CNAME   Debian3

PC8     1h      IN      A       172.17.4.208
PC9     1h      IN      A       172.17.4.209
PC10    1h      IN      A       172.17.4.210
