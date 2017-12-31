#Fri Nov  4 22:32:27 EDT 2016,18.4,49.2
# bash ~/work/poster/post.sh 32 99 'Fri asd ddas 2123 :1233'
# pin_4_20151216-0245-16764.csv

while read line
do
	echo $line
	DT=$(echo $line | cut -d',' -f1)
	T4=$(echo $line | cut -d',' -f2)
	H4=$(echo $line | cut -d',' -f3)

	T25=$(echo $line | cut -d',' -f4)
	H25=$(echo $line | cut -d',' -f5)
	bash ~/work/poster/post.sh $T4 $H4 $T25 $H25 $DT 
done <  $1

