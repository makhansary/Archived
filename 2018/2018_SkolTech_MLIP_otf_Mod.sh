#!/bin/bash 
#
ctoff=5;
lattice=20;
scaling=1;
component='C';
#unitCell=8;
coordinate='Cartesian';
list=$(cat sampled.cfg)
data=0;
for item in ${list//\ / }; 
	do 
		data=$(($data+1));
		echo  $item >> myTEMP;
done
echo loaded data from -sampled.cfg- file
mkdir POSCARs
echo created directory POSCARs
nCFG=`grep -o 'Size' sampled.cfg | wc -l`;
echo number of configurations is $nCFG
currline=1;
captions=6;
skip=2;
ending=16;
for i in `seq 1 $nCFG`; 
do 
	echo processing configuration $i
	lSize=$(($currline+2));
	Size=`sed -n ${lSize}p myTEMP`;
	unitCell=$(($Size)); 
	echo reading atomic positions for configuration $i with size $Size
	currline=$(($captions+$lSize));
	echo writting POSCAR file $i headers 
	echo "$component" >> POSCARs/POSCAR"$i";
	echo "$scaling" >> POSCARs/POSCAR"$i";
	echo "     $lattice     0     0" >> POSCARs/POSCAR"$i";
	echo "     0     $lattice     0" >> POSCARs/POSCAR"$i";
	echo "     0     0     $lattice" >> POSCARs/POSCAR"$i";
	echo "  $component" >> POSCARs/POSCAR"$i";
	echo "  $unitCell" >> POSCARs/POSCAR"$i";
	echo "$coordinate" >> POSCARs/POSCAR"$i";
	echo writing atomic positions in POSCAR$i
	for j in `seq 1 $Size`; 
	do
		currline=$(($currline+$skip+1));
		xPOS=`sed -n ${currline}p myTEMP`;
		currline=$(($currline+1));
		yPOS=`sed -n ${currline}p myTEMP`;
		currline=$(($currline+1));
		zPOS=`sed -n ${currline}p myTEMP`;	
		X=`echo "$xPOS + $ctoff" | bc -l`;
		Y=`echo "$yPOS + $ctoff" | bc -l`;
		Z=`echo "$zPOS + $ctoff" | bc -l`;
		clear;
	done
	currline=$(($currline+$ending));
	currline=$(($currline+1));
done 
# End of file 
