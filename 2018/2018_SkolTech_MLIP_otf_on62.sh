#!/bin/bash
echo ++++++++++++++++++++++++++++++++++++++++
echo file -on62.sh- is open ....
echo on server $(hostname)
echo current directory = $(pwd)
echo ++++++++++++++++++++++++++++++++++++++++
echo reading file CYCLE 
cycle=$(cat "CYCLE")
echo cycle is $cycle 
echo reading file N 
n=$(cat "N")
echo n is $n
for i in `seq 1 $n`;
do
	echo entering directory vaspEF/$i/
	cd vaspEF/$i/ 
	echo $(pwd) on $(hostname)
	echo submitting Slurm for vaspEF run $i
	sbatch -x node-mmm01 -J vaspEF"$i" -N 1 -o vaspEF."$cycle"."$i".out -e vaspEF."$cycle"."$i".err -p MMM ./vasprun.sh
	echo submitted to Slurm for vaspEF run $i
	echo moving back to parent directory
	cd ../../ 
	echo moved to $(pwd) on $(hostname)
done
echo ++++++++++++++++++++++++++++++++++++++++
echo all vaspEF runs are submitted on 10.30.16.62 server
echo monitoring vaspEF runs progress ..... 
for i in `seq 1 $n`;
	do
	echo enterning directory vaspEF/$i/ and looking for file OUTCAR_copy
	cd vaspEF/"$i"/
	echo current directory = $(pwd) on $(hostname)
	while [ ! -f "OUTCAR_copy" ]
		do
			sleep 30s
	done
	echo  file OUTCAR_copy detected in vaspEF/$i/
	echo vaspEF$i completed
	echo moving back to parent directory
	cd ../../
	echo moved to $(pwd) on $(hostname)
done
echo all vaspEF runs finished
echo ++++++++++++++++++++++++++++++++++++++++
echo starting file transfer and then cleaning on 62 
echo transfer ....
scp -i ~/.ssh/id_rsa -r vaspEF mkhansary@10.30.16.61:/home/mkhansary/
echo vaspEF directory is copied under home directory on 61 
echo cleaning vaspEF directory on 62 
rm -r vaspEF
echo removed vaspEF directory on 62
echo cleaning CYCLE and N on 62 
rm CYCLE N 
echo cleaned CYCLE and N on 62
echo ++++++++++++++++++++++++++++++++++++++++
echo closing file -on62.sh- 
echo ++++++++++++++++++++++++++++++++++++++++
# End of file