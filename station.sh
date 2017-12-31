#!/bin/bash

while [ $(date +%Y ) -lt 2016 ] ; 
do 
	sleep 40 
	/home/pi/get_net.sh 
done

getter="sudo Adafruit_DHT 2302"
version=0.1
name=station
# 20130217-1945.log
log_dir=/home/pi/logs/
r=$RANDOM
GET_DATE="date +%Y%m%dT%H%M%SZ"
pins="4 25"
declare -a logs=(${log_dir}pin_4_$($GET_DATE)-$r.csv ${log_dir}pin_25_$($GET_DATE)-$r.csv )
err=${log_dir}err_$($GET_DATE)-$r.log


if [ ! -z $1 ] 
then 
	nap=$1
else
	nap=300
fi

for i in "${logs[@]}"
do
	echo "$i"
#	echo "# $name version $version `date` " > $i
#	echo "# Date, Temp in C, RH in %" >> $i
done


function get_n_log()
{
	pin=$1
	out=$( $getter $pin | grep Temp )
	if [ $? -ne 0 ] 
	then
		sleep 1 # one strike policy, sleep 1 arbitraire.
		echo "# `date` strike 1 for $pin" >> $err
		out=$( $getter $pin | grep Temp )		
		if [ $? -ne 0 ] 
		then
			sleep 2 # exponential back off, 2nd strike.
			echo "# `date` strike 2 for $pin" >> $err 
			out=$( $getter $pin | grep Temp )		
			if [ $? -ne 0 ]
			then
				echo "# `date` unable to read for $2" >> $err
				return
			fi
		fi
	fi
	temp=$(echo $out | grep Temp | awk '{ print $3 }' )
	RH=$(echo $out | grep Hum | awk '{ print $7 }' )
	d=`date`
	echo "$d,$temp,$RH" >> $2 
#	echo "$2:$d,$temp,$RH" 
	
}
function get_data()
{
	out=$( $getter $1 | grep Temp )
        if [ $? -ne 0 ]
        then
                sleep 1 # one strike policy, sleep 1 arbitraire.
                echo "# `date` strike 1 for $1" >> $err
                out=$( $getter $1 | grep Temp )
                if [ $? -ne 0 ]
                then
                        sleep 2 # exponential back off, 2nd strike.
                        echo "# `date` strike 2 for $1" >> $err
                        out=$( $getter $1 | grep Temp )
                        if [ $? -ne 0 ]
                        then
                                echo "# `date` unable to read for $1" >> $err
                                return
                        fi
                fi
        fi
}
function get_n_log_united()
{
	#pin4
	get_data 4
 	temp4=$(echo $out | grep Temp | awk '{ print $3 }' )
        RH4=$(echo $out | grep Hum | awk '{ print $7 }' )
        get_data 25
        temp25=$(echo $out | grep Temp | awk '{ print $3 }' )
        RH25=$(echo $out | grep Hum | awk '{ print $7 }' )
	d=$($GET_DATE)

	if ! bash /home/pi/work/poster/post.sh $temp4 $RH4 $temp25 $RH25 $d
	then 
		echo "$d,$temp4,$RH4,$temp25,$RH25" >> $1
	fi
}
log=${log_dir}united_$($GET_DATE)-$r.csv 
while sleep $nap
do
	/home/pi/get_net.sh 
	get_n_log_united $log
#	for i in "${logs[@]}"
#	do
#		pin=$( echo $i | cut -d'_' -f2 )
#		get_n_log $pin $i
#	done
done
