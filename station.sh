#!/bin/bash

GET_NET=/home/pi/work/truitestation/get_net.sh

while [ $(date +%Y ) -lt 2016 ] ; 
do 
	sleep 40 
	$GET_NET 
done

getter="sudo Adafruit_DHT 2302"
# 20130217-1945.log
log_dir=/home/pi/logs/
r=$RANDOM
GET_DATE="date -Is"
pins="4 25"
err=${log_dir}err_$($GET_DATE)-$r.log

if [ ! -z $1 ]
then 
	nap=$1
else
	nap=300
fi

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

AIOTEMPC4ID=630638
AIOHRID4=630602
AIOTEMPC25ID=630640
AIOHRID25=630639

function get_n_log_united()
{
	#pin4
	get_data 4
	d=$($GET_DATE)
 	temp4=$(echo $out | grep Temp | awk '{ print $3 }' )
    RH4=$(echo $out | grep Hum | awk '{ print $7 }' )
	
	post_adafruit.io $temp4 $AIOTEMPC4ID $d
	post_adafruit.io $RH4 $AIOHRID4 $d
	
	get_data 25
	d=$($GET_DATE)
	temp25=$(echo $out | grep Temp | awk '{ print $3 }' )
	RH25=$(echo $out | grep Hum | awk '{ print $7 }' )
	 
	post_adafruit.io $temp25 $AIOTEMPC25ID $d
	post_adafruit.io $RH25 $AIOHRID25 $d
	
}

function post_adafruit.io () # value ID 
{
	DF=/tmp/data.file.$RANDOM
	cat > $DF << EOF
{ 
"value": "$1", 
"lat": "45.9399757",
"lon": "-74.4134107",
"ele": "439"
}
EOF
	shift
	ID=$1
	curl -k  -H "Content-Type: application/json" -H "X-AIO-Key: $(cat /home/pi/io.adafruit.key)" -X POST https://io.adafruit.com/api/feeds/$ID/data -d @$DF
	ret=$?
	rm $DF
	return $ret 
}

log=${log_dir}united_$($GET_DATE)-$r.csv 
while sleep $nap
do
	$GET_NET
	get_n_log_united $log
done
