# Práctica 3

### El objetivo de esta práctica es:
- Instalar y configurar varios balanceadores que nos permitan repartir el las peticiones entre varios servidores finales.

### Cuestiones a resolver:

1. [x] Crear la organización de red.
2. [x] Instalar y configurar *nginx* como balanceador.
    - [x] Round-Robin.
    - [x] Ponderaciones.
3. [x] Instalar y configurar  *haproxy* como balanceador.
    - [x] Round-Robin.
    - [x] Ponderaciones.
4. [x] Opcional: Instalación y configuración de *Zen Load Balancer*

_________

##### 1. Crear la organización de red.
<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/topologia.png" />
</p>

##### 2. Instalar y configurar *nginx* como balanceador.

En primer lugar instalamos *nginx* en la máquina m3-b mediante la orden `sudo apt-get install nginx`, una vez instalado,
modificamos el archivo ***default.conf*** para que quede como en la siguiente imagen:

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/nginxdefault.png" />
</p>

Una vez hecho esto, reiniciamos *nginx* mediante la orden `sudo service nginx restart` y hacemos uso de `curl` como se
muestra en la imagen para verificar que funciona.

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/roundrobin.png" />
</p>

***En caso de que no funcione, puede ser necesario eliminar /etc/nginx/sites-enabled/default y reiniciar de nuevo***

El algoritmo de balanceo usado anteriormente era round-robin, en caso de querer usar ponderaciones, por ejemplo,
para que 2 de cada 3 peticiones vayan a una máquina, debemos configurarlo de la siguiente forma:

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/weight.png" />
</p>

Ahora volvemos a comprobar el funcionamiento con `curl` y observamos que la máquina 2 recibe más peticiones que la máquina 1:

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/weightcurl.png" />
</p>

##### 3. Instalar y configurar *haproxy* como balanceador.

En primer lugar instalamos *haproxy* mediante el comando `sudo apt-get install haproxy`. Una vez instalamos modificamos
el archivo ***haproxy.cfg*** para que quede como el de la siguiente imagen (pero con las IP que correspondan):

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/haconfig.png" />
</p>

> Aunque la configuración anterior es válida actualmente, debería cambiarse por la que se muestra a continuación,
ya que las líneas indican los timeout están obsoletas y dejarán de ser soportadas en versiones futuras.
<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/haconfig2.png" />
</p>

Ahora iniciamos el servicio mediante la orden `sudo /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg` y comprobamos que
funciona usando la orden `curl`, como se ve en la siguiente figura.

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/curlha.png" />
</p>

La configuración de las ponderaciones en *haproxy* es muy similar a la de *nginx*, como se muestra en la siguiente imagen:
<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/haconfig3.png" />
</p>

Para comprobar que funciona ( 2 de cada 3 peticiones van a la máquina 2) volvemos ha hacer uso de `curl`:
<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/weightha.png" />
</p>

##### 4. Opcional: Instalación y configuración de *Zen Load Balancer* [![Zen Load Balancer](https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/logozen.png)](http://www.zenloadbalancer.com/)

En primer lugar descargamos [**Zen Load Balancer**](http://www.zenloadbalancer.com/community/downloads/),
luego lo instalamos como cualquier otro Linux.


Una vez instalado accedemos a https://ip_zen_load_balancer:444 y nos logueamos con admin, admin.

Una vez logueados vamos a ***Settings > Interfaces > Add virtual network interface*** y creamos y configuramos una IP virtual(si no está ya creada).
<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/zen1.png" />
</p>

Después creamos una granja en ***Manage > Farms > Add farm***

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/zen2.png" />
</p>

Por último editamos la granja SWAP, añadimos el servicio ***backends*** y  añadimos los servidores finales a la granja con la opción ***Add real server*** (En la configuración del servicio ***backends***).

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/zen3.png" />
</p>

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/zen4.png" />
</p>


Para probar el funcionamiento, activamos la granja ( desde la tabla de granjas) y volvemos a hacer uso de `curl`.

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica3/imagenes/zen5.png" />
</p>
