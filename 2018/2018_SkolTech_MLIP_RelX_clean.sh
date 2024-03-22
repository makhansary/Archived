#!/bin/bash
# 
cd dumps
echo $(pwd)
# 
	find . -type f | wc -l > s	
	n=$(cat s)
	echo number of trj files found for relocation --- $n
	n=`expr "$n" / "$n"`
while [ "1" -eq "$n" ]
do
		echo moving trj files to scratch directory  
		mv trj.* ~/../../scratch/mkhansary/tmp/dumps/
		echo moved trj files to scratch directory
		echo sleeping for 5 minutes
		sleep 5m
		echo slept 5 minutes
	rm s
	echo removed file s 
	echo rechecking presence of dump files 
	find . -type f | wc -l > s	
	echo rechecked presence of dump files 
	n=$(cat s)
	echo number of trj files found for relocation --- $n
	n=`expr "$n" / "$n"`
done
#
# End of file 
