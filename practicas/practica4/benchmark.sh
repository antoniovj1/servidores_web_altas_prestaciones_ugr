#!/bin/bash


if [ $# -ne 2 ];then
	echo " *********Benchmark ab y siege**********"
	echo "Uso -> sh benchmark.sh IP nombre_final_archivo"
else

	let porcentaje=20

	echo "Ejecutando ab..."
	for i in {1..5} 
	do
 		ab -s 350 -r -n 100000 -c 500 http://$1/ >> ab_$2.txt 2>&1

 		sleep 60

 		echo -n $porcentaje '%...'
 		let porcentaje="$porcentaje+20"
	done

	echo "Esperando 3 min..."
	sleep 180

	let porcentaje=20

	echo "Ejecutando siege..."
	for i in {1..5} 
	do
 		siege -b -t40S -v http://$1/ >> sigue_$2.txt 2>&1

 		sleep 60
 		echo -n $porcentaje '%...'
 		let porcentaje="$porcentaje+20"
	done

	sed '/33m/ d' siege_$2.txt > t1.txt
	sed '/34mHTTP/ d' t1.txt > siege_$2_recortado.txt
	rm t1.txt

fi
