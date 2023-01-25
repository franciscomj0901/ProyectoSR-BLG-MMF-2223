                                                                       /var/lib/bind/db.equipos.com                                                                                         
$TTL    604800
equipos.produccion.com.    IN      SOA       Debian5 admin(
                        7       ;Serial
                        604800  ;Refresh
                        86400   ;Retry
                        2419200 ;Expire
                        604800) ;Negative Cache TTL

;Servidores de nombre
@       IN      NS      Debian5.servidoresdns.equipos.produccion.com.
        IN      NS      Debian6.servidoresdns.equipos.produccion.com.

$ORIGIN almacen.equipos.produccion.com.
PC1     IN      A       172.17.4.201
Debian2 IN      A       172.17.4.102

$ORIGIN finanzas.equipos.produccion.com.
PC3     1h      IN      A       172.17.4.203
PC4     1h      IN      A       172.17.4.204
PC5     1h      IN      A       172.17.4.205

$ORIGIN servidoresdns.equipos.produccion.com.
Debian5     1h      IN      A       172.17.4.105
servidordns1        IN      CNAME   Debian5

Debian6     1h      IN      A       172.17.4.106
servidordns2        IN      CNAME   Debian6

