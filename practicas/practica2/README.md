# Práctica 2

### Los objetivos concretos de esta segunda práctica son:
- aprender a copiar archivos mediante ssh
- clonar contenido entre máquinas
- configurar el ssh para acceder a máquinas remotas sin contraseña
- establecer tareas en cron

### Cuestiones a resolver:

1. [x] probar el funcionamiento de la copia de archivos por ssh
2. [x] clonado de una carpeta entre las dos máquinas
3. [x] configuración de ssh para acceder sin que solicite contraseña
4. [x] establecer una tarea en cron que se ejecute cada hora para mantener actualizado el contenido del directorio /var/www entre las dos máquinas


_________



#### 1. Probar el funcionamiento de la copia de archivos por SSH.

 En primer lugar debemos instalar el servidor de SHH en la máquina a la que nos queremos conectar, para ello ejecutamos la orden   `sudo apt-get instal openssh-server`.

 Una vez que lo tenemos instalado, nos dirigimos a la máquina "cliente" ( en la que no hemos instalado *openssh-server* ) creamos unos cuantos archivos y ejecutamos a orden tar junto a SSH como se muestra en la siguiente imagen.

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/1.png" />
</p>

En la otra máquina ( a la que hemos transferido los archivos ) comprobamos si la transferencia ha sido exitosa, si es así debe haber un archivo llamado **tar.tgz**, como se muestra a continuación.

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/2.png" />
</p>

#### 2. Clonado de una carpeta entre las dos máquinas.

Para empezar,en caso de que *rsync* no esté instalado, lo instalamos mediante la orden `sudo apt-get install rsync`.
Además de instalar *rsync* debemos comprobar que en la configuración del SSH se permite el acceso con root, si no es así, modificamos la opción y reiniciamos el servicio (`service ssh restart`).

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/3.png" />
</p>

Ahora que todo está preparado probamos el comando `rsync` para comprobar que funciona correctamente, como se ve en la siguiente imagen.
<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/4.png" />
</p>

#### 3.Configuración de SSH para acceder sin introducir contraseña.

En la máquina "cliente" ( la que se va a conectar ), creamos una clave y no le ponemos ninguna contraseña, en mi caso he creado un clave RSA, como se muestra a continuación.
<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/5.png" />
</p>

Una vez que hemos creado la clave, tenemos que transferirla a la otra máquina, para ello realizamos lo siguiente:
<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/6.png" />
</p>

Una vez realizado esto, ya deberíamos poder conectarnos sin introducir ninguna contraseña.

#### 4. Establecer una tarea en cron que se ejecute cada hora para mantener actualizado el contenido del directorio /var/www entre las dos máquinas.

Para este apartado tan solo tenemos que ejecutar la orden `crontab -e` (estando logueados como root), que nos permite editar el *crontab* del usuario actual. Después de ejecutar la orden deberemos añadir una línea como la siguiente y nuestros directorios quedarán sincronizados:

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica2/imagenes/7.png" />
</p>

> La línea mostrada en la imagen se ejecuta cada minuto en lugar de cada hora, hice esto para poder probar que funcionaba correctamente sin tener que esperar mucho, para que se ejecutará cada hora, el principio de la orden sería `0 * * * *` además se podría quitar el `/1` que aparece en la imagen.
