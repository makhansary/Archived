#!/bin/bash
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo file -lmpS2.sh- is open ....
echo current directory = $(pwd)
echo on server $(hostname)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
echo submitting 128 lammps MD jobs 
echo current directory = $(pwd) 
echo ++++++++++++++++++++++++++++++++++++++++
echo lammps tasks 1-32
echo "1" > ../tmp/InitINST
lmpINS=$(cat ../tmp/InitINST)
lmpEnd=`expr "$lmpINS" + 31`
echo executing lamprun.sh script ... 
./lmprun.sh
echo checking whether last instace -$lmpEnd-is launched or not to start monitoring 
while [ ! -d ../runs/$cycle/lmpRX/$lmpEnd/ ]
do
		sleep 30s
done
echo checking lammps run progress and termination ...
for j in `seq $lmpINS $lmpEnd`;
do
	echo checking whether lmpRXrun=$j is completed or not
	echo entering directory ../runs/$cycle/lmpRX/$j/
	cd ../runs/"$cycle"/lmpRX/"$j"/
	echo current directory = $(pwd)
	echo monitoring presence of file -lmpRXfinished-
	while [ ! -f "lmpRXfinished" ]
		do
			sleep 30s
	done
	echo file -lmpRXfinished- detected in directory ../runs/$cycle/lmpRX/$j/
	echo leaving directory ../runs/$cycle/lmpRX/$j/
	cd ../../../../sh/
	echo current directory = $(pwd)
done
echo ++++++++++++++++++++++++++++++++++++++++
echo lammps tasks 33-64
echo "33" > ../tmp/InitINST
lmpINS=$(cat ../tmp/InitINST)
lmpEnd=`expr "$lmpINS" + 15`
echo executing lamprun.sh script ... 
./lmprun.sh
echo checking whether last instace -$lmpEnd-is launched or not to start monitoring 
while [ ! -d ../runs/$cycle/lmpRX/$lmpEnd/ ]
do
		sleep 30s
done
echo checking lammps run progress and termination ...
for j in `seq $lmpINS $lmpEnd`;
do
	echo checking whether lmpRXrun=$j is completed or not
	echo entering directory ../runs/$cycle/lmpRX/$j/
	cd ../runs/"$cycle"/lmpRX/"$j"/
	echo current directory = $(pwd)
	echo monitoring presence of file -lmpRXfinished-
	while [ ! -f "lmpRXfinished" ]
		do
			sleep 30s
	done
	echo file -lmpRXfinished- detected in directory ../runs/$cycle/lmpRX/$j/
	echo leaving directory ../runs/$cycle/lmpRX/$j/
	cd ../../../../sh/
	echo current directory = $(pwd)
done
echo ++++++++++++++++++++++++++++++++++++++++
echo lammps tasks 65-96
echo "65" > ../tmp/InitINST
lmpINS=$(cat ../tmp/InitINST)
lmpEnd=`expr "$lmpINS" + 15`
echo executing lamprun.sh script ... 
./lmprun.sh
echo checking whether last instace -$lmpEnd-is launched or not to start monitoring 
while [ ! -d ../runs/$cycle/lmpRX/$lmpEnd/ ]
do
		sleep 30s
done
echo checking lammps run progress and termination ...
for j in `seq $lmpINS $lmpEnd`;
do
	echo checking whether lmpRXrun=$j is completed or not
	echo entering directory ../runs/$cycle/lmpRX/$j/
	cd ../runs/"$cycle"/lmpRX/"$j"/
	echo current directory = $(pwd)
	echo monitoring presence of file -lmpRXfinished-
	while [ ! -f "lmpRXfinished" ]
		do
			sleep 30s
	done
	echo file -lmpRXfinished- detected in directory ../runs/$cycle/lmpRX/$j/
	echo leaving directory ../runs/$cycle/lmpRX/$j/
	cd ../../../../sh/
	echo current directory = $(pwd)
done 
echo ++++++++++++++++++++++++++++++++++++++++
echo lammps tasks 97-128
echo "97" > ../tmp/InitINST
lmpINS=$(cat ../tmp/InitINST)
lmpEnd=`expr "$lmpINS" + 15`
echo executing lamprun.sh script ... 
./lmprun.sh
echo checking whether last instace -$lmpEnd-is launched or not to start monitoring 
while [ ! -d ../runs/$cycle/lmpRX/$lmpEnd/ ]
do
		sleep 30s
done
echo checking lammps run progress and termination ...
for j in `seq $lmpINS $lmpEnd`;
do
	echo checking whether lmpRXrun=$j is completed or not
	echo entering directory ../runs/$cycle/lmpRX/$j/
	cd ../runs/"$cycle"/lmpRX/"$j"/
	echo current directory = $(pwd)
	echo monitoring presence of file -lmpRXfinished-
	while [ ! -f "lmpRXfinished" ]
		do
			sleep 30s
	done
	echo file -lmpRXfinished- detected in directory ../runs/$cycle/lmpRX/$j/
	echo leaving directory ../runs/$cycle/lmpRX/$j/
	cd ../../../../sh/
	echo current directory = $(pwd)
done
echo ++++++++++++++++++++++++++++++++++++++++
echo closing file lmpS1.sh 
#echo reverting setting threat spreading ... 
#export OMP_NUM_THREADS=16
#echo exporting OMP_NUM_THREADS as 16
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 
