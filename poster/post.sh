#curl "https://docs.google.com/forms/d/SECRET/formResponse?ifq&entry.1202908243=Hello%20World&submit=Submit"
FORMID='SECRET'
DATEID=
TEMPC4ID=entry.1453294870
AIOTEMPC4ID=630638
HRID4=entry.388314209
AIOHRID4=630602
TEMPC25ID=entry.1233189316
AIOTEMPC25ID=630640
HRID25=entry.1110828198
AIOHRID25=630639
DATEMONTHID=entry.1146907600_month
DATEYEARID=entry.1146907600_year
DATEDAYID=entry.1146907600_day
TIMEHOURID=entry.1068311095_hour
TIMEMINID=entry.1068311095_minute
DATETIMEID=entry.1146907600
PINID=entry.2032575221

if [ $# -le 3 ] 
then
	echo "not 3, $#:  $@ "
	echo "Usage: $0 TEMPC HR PIN DATETIME"   
	exit 1
fi 
#echo $1
T=$1
shift
#echo $1
H=$1
shift
#echo $1
T25=$1
shift
H25=$1
shift
DT=$@
DT=$(echo $DT | sed 's/ /%20/g' ) 
#curl "https://docs.google.com/forms/d/e/$FORMID/formResponse?ifq&$HRID=allomonde&$TEMPCID=Hello%20World&submit=Submit"
# googe mode curl -f "https://docs.google.com/forms/d/e/$FORMID/formResponse?ifq&$PINID=$P&$DATETIMEID=$DT&$TEMPC4ID=$T&$HRID4=$H&$TEMPC25ID=$T25&$HRID25=$H25&submit=Submit" > /dev/null
set -x 
/home/pi/work/truitestation/poster/post_adaio_value_id.sh  $T $AIOTEMPC4ID
/home/pi/work/truitestation/poster/post_adaio_value_id.sh  $H $AIOHRID4

/home/pi/work/truitestation/poster/post_adaio_value_id.sh  $T25 $AIOTEMPC25ID
/home/pi/work/truitestation/poster/post_adaio_value_id.sh  $H25 $AIOHRID25

