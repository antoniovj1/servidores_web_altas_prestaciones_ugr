# Práctica 4

### El objetivo de esta práctica es:
- Ejecutar distintos benchmarks para comprobar la utilidad del balanceo de carga.

### Cuestiones a resolver:

1. [x] Ejecutar *Apache Benchmark* sobre:
    - [x] Servidor solo.
    - [x] Servidor con balanceador *nginx*.
    - [x] Servidor con balanceador *haproxy*.
2. [x] Ejecutar *siege* sobre:
    - [x] Servidor solo.
    - [x] Servidor con balanceador *nginx*.
    - [x] Servidor con balanceador *haproxy*.
3. [x] Conlcusión.


_________


Para todos los test realizados he usado el script benchmark.sh

##### 1. *Apache Benchmark*.

Haciendo uso de *Apache Benchmark*, podemos ver que el balanceador más rápido es HAporxy y que como cabía esperar la configuración más lenta es en la que se usa un servidor solo ( Figura 1.1 ), por otro lado podemos ver que el uso del balanceo de carga afecta en gran medida a la capacidad de servir peticiones, ya que  como se puede ver en la figura 1.2, hay una diferencia abismal entre el número de peticiones fallidas usando un balanceador en comparación con usar un servidor solo. Por último, aunque no existen diferencias tan significativas como en el caso anterior, podemos ver que haciendo uso de un balanceador de carga podemos aumentar el número de peticiones por segundo que pueden ser servidas ( Figura 1.3 ).

<p>
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image7.png" />
<figcaption>Fig 1.1. - Tiempo de ejecución de ab.</figcaption>
</p>

<p>
 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image8.png" />
<figcaption>Fig 1.2. - Número de peticiones fallidas.</figcaption>
</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image9.png" />
<figcaption>Fig 1.3. - Número de peticiones por segundo.</figcaption>

</p>

##### 2. *Siege*.

Haciendo uso de *Siege* llegamos a unos resultados muy similares a los obtenidos con *Apache Benchmark* , como podemos ver en las gráficas que se muestran a continuación. La única situación extraña es la mostrada en la figura 2.6, ya que el servidor solo, es un poco mejor que la granja usando *nginx* como balanceador.


<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image.png" />
<figcaption>Fig 2.1. - Número de peticiones completadas.</figcaption>

</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image1.png" />
<figcaption>Fig 2.2. - Número de peticiones fallidas.</figcaption>

</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image2.png" />
<figcaption>Fig 2.3. - Tiempo de respuesta.</figcaption>

</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image3.png" />
<figcaption>Fig 2.4. - Disponibilidad.</figcaption>

</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image4.png" />
<figcaption>Fig 2.5. - Tiempo transcurrido en el test.</figcaption>

</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image5.png" />
<figcaption>Fig 2.6. - Número de peticiones por segundo.</figcaption>

</p>

<p>

 <img src="https://github.com/antoniovj1/servidores_web_altas_prestaciones_ugr/blob/master/practicas/practica4/imagenes/image6.png" />
<figcaption>Fig 2.7. - Concurrencia.</figcaption>

</p>



##### 3. Conclusión.

Una vez visto todos los resultados, podemos concluir que *HAporxy* balancea de forma más eficiente que *nginx* y que en cualquier caso ( que requiera una carga considerable) es mejor usar una configuración con un balanceador de carga que un servidor solo.
