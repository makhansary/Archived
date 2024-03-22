#!/bin/bash
# 
grep -n 'Loop' log.min > out;
sed -e 's/:.*//' out > lines;
rm out;
line=$(cat lines);
rm lines;
for l in ${line//\ / }; 
	do 
	L=$(($l-1));
	res=`sed -n ${L}p log.min`;
	echo  $res >> Data;
done
