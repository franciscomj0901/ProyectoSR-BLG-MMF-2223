$TTL    604800
$ORIGIN routers.produccion.com.
routers.produccion.com.    IN      SOA       Debian5 admin(
                        7       ;Serial
                        604800  ;Refresh
                        86400   ;Retry
                        2419200 ;Expire
                        604800) ;Negative Cache TTL

;Servidores de nombre
@       IN      NS      Debian5.servidoresdns.equipos.produccion.com.
        IN      NS      Debian6.servidoresdns.equipos.produccion.com.

; Estaciones de trabajo
Debian1 IN      A       172.17.4.10
        IN      A       172.17.5.10
enrutador     IN      CNAME   Debian1

