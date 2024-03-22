#!/bin/bash
#
echo ++++++++++++++++++++++++++++++++++++++++
echo file lmprun.sh is open
echo on server $(hostname)
echo current directory = $(pwd) 
echo setting threat spreading ... 
export OMP_NUM_THREADS=1
echo exporting OMP_NUM_THREADS as 1  
echo ++++++++++++++++++++++++++++++++++++++++
echo reading file CYCLE
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
lmpINS=$(cat ../tmp/InitINST)
lmpEnd=`expr "$lmpINS" + 31`
echo submitting 32 jobs starting from $lmpINS to $lmpEnd
echo ++++++++++++++++++++++++++++++++++++++++
echo determining lammps input file to execute  
mode=$(cat ../usr/"MODE")
echo mode is $mode - info -- 0=genMTP-1=ExtSys-2=Neigh-
echo ++++++++++++++++++++++++++++++++++++++++
echo setting flags for lammps input file based on the selected -mode-
if [ "$mode" -eq "0" ]; then
	lmpTXT="genMTP"
fi
if [ "$mode" -eq "1" ]; then
	lmpTXT="ExtSys"
fi
if [ "$mode" -eq "2" ]; then
	if [ "$cycle" -eq "0" ]; then
		lmpTXT="Neigh1"
	else 
		lmpTXT="Neigh2"
	fi 
fi
echo ++++++++++++++++++++++++++++++++++++++++
echo lmpRX input file in use is $lmpTXT 
echo ++++++++++++++++++++++++++++++++++++++++
echo looping from $lmpINS to $lmpEnd
for j in `seq $lmpINS $lmpEnd`;
do 
	echo creating directory in ../runs/$cycle/lmpRX/$j for lammps instance $j
	mkdir ../runs/"$cycle"/lmpRX/"$j"
	echo directory is created at ../runs/$cycle/lmpRX/$j
	echo preparing lammps files
	echo copying lammps data file from: ../inp/data.cfgs to ../runs/$cycle/lmpRX/$j
	cp ../inp/data.cfgs ../runs/"$cycle"/lmpRX/"$j"/
	echo copied ../inp/data.cfgs to ../runs/$cycle/lmpRX/$j
	echo copying lammps input file from: ../src/lmp/ to ../runs/$cycle/lmpRX/$j
	cp ../src/lmp/in."$lmpTXT" ../runs/"$cycle"/lmpRX/"$j"/
	echo copied ../src/lmp/in.$lmpTXT to ../runs/$cycle/lmpRX/$j
	echo start launching lmpRX runs
	echo entering ../runs/$cycle/lmpRX/$j directory to launch lmpRX run = $j
	cd ../runs/"$cycle"/lmpRX/"$j"/
	echo current directory = $(pwd)
	echo creating directory for dump files at ../runs/$cycle/lmpRX/$j/dumps/
	mkdir dumps
	echo created directory ../runs/$cycle/lmpRX/$j/dumps/
	echo executing lammps input script using --lmp_serial-- binary 
	../../../../src/lmp/lmp_serial<in."$lmpTXT" -var seed `bash -c 'echo $RANDOM'` > ../../../../tmp/lmp."$cycle"."$j".out &
	echo submitted job for lammps instance $j
	echo ++++++++++++++++++++++++++++++++++++++++
	echo leaving directory ../runs/$cycle/lmpRX/$j/
	cd ../../../../sh
	echo current directory = $(pwd)
done
echo submitted 32 lammps MD tasks from $lmpINS to $lmpEnd 
echo executing wait command ... 
wait 
echo completed lammps jobs from $lmpINS to $lmpEnd
echo ++++++++++++++++++++++++++++++++++++++++
echo exporting completion flag into the file -lmpRXfinished-
for j in `seq $lmpINS $lmpEnd`;
do
	echo completion status is set for ../runs/$cycle/lmpRX/$j/   
	echo "1">../runs/"$cycle"/lmpRX/"$j"/lmpRXfinished
done 
echo finished exporting completion flag into the file -lmpRXfinished-
echo ++++++++++++++++++++++++++++++++++++++++
echo file lmprun.sh is closed 
echo ++++++++++++++++++++++++++++++++++++++++
# End 
