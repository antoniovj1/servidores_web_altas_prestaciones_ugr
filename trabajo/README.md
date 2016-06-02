# Trabajo SWAP - NAS con RAID 0 en RaspberryPi 3

### Índice:

1.  Definición de RAID 0.
2.  Definición de NAS.
3.  Instalación y configuración.
    1. Configuración e instalación del RAID 0.
    2. Configuración de la carpeta compartida.
    3. Configuración de Samba.
4.  Referencias.


##### 1. Definición de RAID 0

Un RAID 0 (también llamado conjunto dividido, volumen dividido, volumen seccionado) distribuye los datos equitativamente entre dos o más discos (usualmente se ocupa el mismo espacio en dos o más discos) sin información de paridad que proporcione redundancia. El RAID 0 se usa normalmente para proporcionar un alto rendimiento de lectura o para obtener un disco de un tamaño mayor.

##### 2. Definición de NAS

El almacenamiento conectado en red, Network Attached Storage (NAS), es el nombre dado a una tecnología de almacenamiento dedicada a compartir la capacidad de almacenamiento de un computador (servidor) con computadoras personales o servidores clientes a través de una red (normalmente TCP/IP).


##### 3.1. Configuración e instalación del RAID 0.

En primer lugar instalamos mdadm, una utilidad necesaria para crear y administrar los RAID.

```
sudo apt-get install mdadm
```

Luego comprobamos que los discos han sido detectados correctamente haciendo uso del comando `lsblk`.

Una vez que hemos comprobado que los discos han sido detectados, pasamos a crear el RAID 0 mediante el comando:

```
mdadm -Cv /dev/md0 -l0 -n2 /dev/sd[ab]1
```
Una vez creado, le damos formato mediante el comando:

```
sudo mkfs /dev/md0 -t ext4
```


Una vez realizados estos pasos el RAID debe estar funcionando, para comprobarlo usamos el comando:

```
mdadm --detail /dev/md0
```

Tras ejecutar el comando debemos obtener una salida similar a la siguiente:

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/trabajo/mdadm.png" />
</p>


##### 3.2. Configuración de la carpeta compartida.

Una vez que tenemos el RAID creamos una carpeta en la que se motará en RAID y que se compartirá mediante Samba.

```
sudo mkdir /mnt/raid0
sudo mount /dev/md0 /mnt/raid0
sudo fdisk -l o sudo blkid
sudo nano /etc/fstab
```

En el fstab debemos añadir una línea similar a la que se muestra en la última linea de la siguiente imagen (también se podría haber hecho usando el UUID) para que el RAID se monte automaticamente al inicio:

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/trabajo/fstab.png" />
</p>


##### 3.3. Configuración e instalación de Samba.


Para realizar la compartición de la carpeta usaremos Samba, para ello lo instalamos mediante el siguiente comando:

```
sudo apt-get install samba samba-common-bin
```

Luego hacemos una copia de seguridad del archivo de configurción de Samba:
```
sudo cp /etc/samba/smb.conf smb.old
```

Por último editamos el archivo de configuración:

```
sudo nano /etc/samba/smb.conf
```

En el archivo de configuración realizamos los cambios que creamos necesarios para nuestro uso, en nuestro caso hemos optado por la siguiente configuración:

<p align="center">
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/trabajo/samba.png" />
</p>



##### 4. Referencias.

[Raspberry Pi raid array with USB HDDs](http://projpi.com/diy-home-projects-with-a-raspberry-pi/raspberry-pi-raid-array-with-usb-hdds/)

[Raspberry Pi : Automount USB](http://projpi.com/raspberry-pi-tips-and-hacks/raspberry-pi-automount-usb/)

[Instalar SAMBA : preparando un NAS o servidor casero 3](https://raspberryparatorpes.net/proyectos/instalar-samba-preparando-un-nas-o-servidor-casero-3/)

[RAID - Wikipedia](https://es.wikipedia.org/wiki/RAID)
[NAS - Wikipedia](https://es.wikipedia.org/wiki/Almacenamiento_conectado_en_red)

[mdadm(8) - Linux man page](http://linux.die.net/man/8/mdadm)


___

Antonio de la Vega Jiménez
-
Víctor Vallecillo Morilla
-


###### Universidad de Granada (UGR)
___
