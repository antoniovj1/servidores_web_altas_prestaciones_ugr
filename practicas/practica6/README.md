# Práctica 6

### Los objetivos concretos de esta quinta práctica son:
- configurar discos RAID

### Cuestiones a resolver:

1. [x] Realizar la configuración de dos discos en RAID 1, automatizando el montaje del dispositivo creado al inicio del sistema. 
2. [x] Simular un fallo en uno de los discos del RAID (mediante comandos con el mdadm), retirarlo“en caliente”, comprobar que se puede acceder a la información que hay almacenada en el RAID, y por último, añadirlo al conjunto y comprobar que se reconstruye correctamente


_________

> En primer lugar añadimos dos discos del mismo tamaño a nuestra máquina.

#### 1. Crear una BD con al menos una tabla y algunos datos.


Primero instalamos `mdadm`mediante el comando `sudo apt-get install mdadm`.

Luego comprobamos que los discos se han detectado correctamente con el comando `sudo fdisk -l`.

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/fdisk.png" />
</p>

Ahora creamos el RAID 1 usando el siguiente comando:

```
sudo mdadm -C /dev/md0 --level=raid1 --raid-devices=2 /dev/sd[bc]
```
<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/crear_raid.png" />
</p>


Ahora le damos formato al RAID y creamos el directorio donde se montará:

```
sudo mkfs /dev/md0

sudo mkdir /dat

sudo mount /dev/md0 /dat
```


Luego comprobamos si el RAID está funcionando correctamente haciendo uso del comando sudo mdadm --detail /dev/md127  (127 porque md0 se renonmbra tras reiniciar la máquina).

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/detail.png" />
</p>


Ahora obtenemos el UUID del RAID y lo añadimos en el archivo `/etc/fstab`para que el RAID se monte automáticamente.


<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/uuid.png" />
</p>


<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/fstab.png" />
</p>


Ahora simulamos un fallo, retiramos el disco y comprobamos que se ha eliminado correctamente, para ello usamos los comandos:

```
sudo mdadm --manage --set-faulty /dev/md127 /dev/sdb

sudo mdadm --manage --remove /dev/md127 /dev/sdb

sudo mdadm --detail /dev/md127 

```


<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/fail.png" />
</p>



Una vez hecho esto volvemos a insertar un disco y comprobamos si el RAID se reconstruye correctamente:

```
sudo mdadm --manage --add /dev/md127 /dev/sdb

sudo mdadm --detail /dev/md127 

```

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica6/imagenes/test.png" />
</p>












