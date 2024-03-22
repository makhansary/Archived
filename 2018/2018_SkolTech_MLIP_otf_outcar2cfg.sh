#!/bin/bash
#
echo ++++++++++++++++++++++++++++++++++++++++
echo file -outcar2cfg.sh- is open ....
echo current directory = $(pwd)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
echo reading file N 
n=$(cat ../tmp/"N")
echo n is $n
echo executing MLIP convert command 
for i in `seq 1 $n`;
    do
	echo appending OUTCAR from: ../runs/$cycle/vaspEF/$i/OUTCAR to ../runs/$cycle/mlip/trainsetN.cfg
	echo launching MLIP convert command 
    ../src/mlip/mlp convert-cfg ../runs/"$cycle"/vaspEF/"$i"/OUTCAR ../runs/"$cycle"/mlip/trainsetN.cfg --input-format=vasp-outcar --append --elements-order=0
done
echo appending CFG file finished - trainset with E and F is generated as ../runs/$cycle/mlip/trainsetN.cfg
echo closing file -outcar2cfg.sh-  
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 