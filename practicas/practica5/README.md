# Práctica 5

### Los objetivos concretos de esta quinta práctica son:
- aprender a usar mysqldump
- sincronizar bases de datos con una configuración maestro-esclavo
- sincronizar bases de datos con una configuración maestro-maestro

### Cuestiones a resolver:

1. [x] Crear una BD con al menos una tabla y algunos datos.
2. [x] Realizar la copia de seguridad de la BD completa usando mysqldump.
3. [x] Restaurar dicha copia en la segunda máquina.
4. [x] Realizar la configuración maestro-esclavo de los servidores MySQL para que la replicación de datos se realice automáticamente.
5. [x] [OPCIONAL] Realizar la configuración maestro-maestro de los servidores MySQL para que la replicación de datos se realice automáticamente.
_________

> En primer lugar instalamos MySQL usando el comando `sudo apt-get install mysql-server`

#### 1. Crear una BD con al menos una tabla y algunos datos.

 En primer lugar crearemos una base de datos, para ello accederemos a la consola de MySQL mediante el comando `mysql -uroot -p`.

Una vez que hemos accedido crearemos la base de datos y añadiremos una fila mediante las siguientes ordenes:

```sql
CREATE DATABASE contactos;

USE contactos;

CREATE TABLE datos(nombre varchar(100), tlf int);

INSERT INTO datos(nombre,tlf) VALUES ("antonio",956956956);

```

Podemos comprobar si la base de datos se ha creado correctamente usando los comandos mostrados en la siguiente imagen:

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica5/imagenes/test_mysql.png" />
</p>

#### 2. Realizar la copia de seguridad de la BD completa usando mysqldump.

Para realizar la copia de seguridad con mysqldump primero debemos bloquear la base de datos para evitar que se añada nueva información mientras estamos realizando la copia, luego hacemos la copia y finalmente volvemos a desbloquear la base de datos. Para realizar esto debemos ejecutar los siguiente comandos:

```sql

mysql -u root -p

mysql> FLUSH TABLES WITH READ LOCK;
mysql> quit

mysqldump contactos -u root -p > /home/antonio/contactosdb.sql

mysql -u root -p

mysql> UNLOCK TABLES;
mysql> quit

```

#### 3.Restaurar dicha copia en la segunda máquina.

Una vez que hemos realizado la copia de seguridad, accedemos a la otra máquina y descargamos el archivo SQL, para ello podemos usar el comando `sudo scp antonio@10.0.2.15:/home/antonio/contactosdb.sql /home/antonio `

Ahora que ya tenemos el archivo SQL, debemos crear la base de datos a mano y luego importar la información del archivo:

```sql
mysql -u root -p

mysql> CREATE DATABASE `contactos`;
mysql> quit

mysql -u root -p contactos < /home/antonio/contactosdb.sql

```


#### 4. Realizar la configuración maestro-esclavo de los servidores MySQL para que la replicación de datos se realice automáticamente.


En primer lugar editamos como root el archivo `/etc/mysql/my.cnf` del servidor maestro  y realizamos los siguientes cambios:

```
Comentamos el parámetro bind-address
#bind-address 127.0.0.1

Indicamos el archivo de logs
log_error = /var/log/mysql/error.log
log_bin = /var/log/mysql/bin.log

Especificamos el id del servidor
server-id = 1

Reiniciamos el servidor
/etc/init.d/mysql restart

```

Una vez que tenemos el maestro configurado, pasamos a configurar el esclavo, para ello volveremos a editar el archivo `/etc/mysql/my.cnf` y realizar los siguientes cambios:


```
Comentamos el parámetro bind-address
#bind-address 127.0.0.1

Indicamos el archivo de logs
log_error = /var/log/mysql/error.log
log_bin = /var/log/mysql/mysql-bin.log

Especificamos el id del servidor
server-id = 2

Reiniciamos el servidor
/etc/init.d/mysql restart

```

Ahora que ya tenemos configurados tanto el maestro como el esclavo, volvemos al maestro y creamos un
usuario con permisos para la replicación:

```sql
mysql -u root -p

CREATE USER esclavo IDENTIFIED BY 'esclavo';

GRANT REPLICATION SLAVE ON *.* TO 'esclavo'@'%' IDENTIFIED BY 'esclavo';

FLUSH PRIVILEGES;

FLUSH TABLES;

FLUSH TABLES WITH READ LOCK;

Obtenemos la información de la base de datos que vamos a replicar para luego usarlo en la configuración
del esclavo

SHOW MASTER STATUS;

```

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica5/imagenes/master_status.png" />
</p>


Ahora vamos al esclavo y configuramos el maestro con la información de la imagen anterior:

```sql
mysql -u root -p

CHANGE MASTER TO MASTER_HOST='10.0.2.15', MASTER_USER='esclavo',
    MASTER_PASSWORD='esclavo',
    MASTER_LOG_FILE='mysql-bin.000004',
    MASTER_LOG_POS=107,MASTER_PORT=3306;

START SLAVE;
```
 Para comprobar si todo ha funcionado correctamente,
  volvemos al maestro, desbloqueamos las tablas y en el esclavo comprobamos su estado:

```sql

#En el maestro
mysql> UNLOCK TABLES;

#En el esclavo

mysql> SHOW SLAVE STATUS\G


```

Comprobamos que el valor de `Seconds_Behind_Master` sea distinto de `null`

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica5/imagenes/status_slave.png" />
</p>


Por último comprobamos que la sincronización se lleva a cabo correctamente, como se muestra a continuación:

<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica5/imagenes/test_ms.png" />
</p>



#### 5.[OPCIONAL] Realizar la configuración maestro-maestro de los servidores MySQL para que la replicación de datos se realice automáticamente.

Para la configuración maestro-maestro debemos realizar las mismas configuraciones que realizamos antes pero a la inversa:

En el que antes era el servidor esclavo creamos un usuario con permisos para replicación:

```sql
mysql -u root -p

CREATE USER esclavo IDENTIFIED BY 'esclavo';

GRANT REPLICATION SLAVE ON *.* TO 'esclavo'@'%' IDENTIFIED BY 'esclavo';

FLUSH PRIVILEGES;

FLUSH TABLES;

FLUSH TABLES WITH READ LOCK;

Obtenemos la información de la base de datos que vamos a replicar para luego usarlo en la configuración
del esclavo

SHOW MASTER STATUS;

```


Ahora vamos al "esclavo"(el que antes era maestro) y configuramos el maestro con la información de la imagen anterior:

```sql
mysql -u root -p

CHANGE MASTER TO MASTER_HOST='10.0.2.4', MASTER_USER='esclavo',
    MASTER_PASSWORD='esclavo',
    MASTER_LOG_FILE='mysql-bin.000003',
    MASTER_LOG_POS=501,MASTER_PORT=3306;

START SLAVE;
```

Finalmente comprobamos que todo funciona correctamente introduciendo algunos datos en nuestra BD:


<p align="center">
  <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica5/imagenes/test_mm.png" />
</p>






