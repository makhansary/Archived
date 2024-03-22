#!/bin/bash
#
echo ++++++++++++++++++++++++++++++++++++++++
echo checkfail.sh file is open 
echo current directory = $(pwd)
echo on server $(hostname)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
echo reading file M
m=$(cat ../tmp/"M")
echo number of lammps instances -m- is $m 
sumfails=0
for j in `seq 1 $m`;
do
    echo entering directory ../runs/$cycle/lmpRX/$j/
    cd ../runs/"$cycle"/lmpRX/"$j"/
	echo current directory = $(pwd)
    echo detecting the existence of file -selected- and writing its presence into file -existF-
   	find . -name 'selected.c*' | wc -l > existF
	echo generated file existF  
    echo reading content of file -existF-
    selected_exist=$(cat "existF")
	if [ "$selected_exist" -eq "1" ]; then
		echo file -selected- is detected for lammps instance $j
		sumfails=$(($sumfails+1))
		echo number of detected -selected- file up to now = $sumfails 
        echo appending content of file -selected.cfg- to ../runs/$cycle/mlip/selected.cfg
		# file -selected.cfg- is empty initially 
        cat selected.c* >> ../../mlip/selected.cfg
		echo appended content of file -selected.cfg- to ../runs/$cycle/mlip/selected.cfg
    else
    	echo no file -selected- is detected for lammps instance $j
		echo lmpRXrun instance $j is successfull
		echo no CFG file collection is needed 
    fi
echo leaving directory ../runs/$cycle/lmpRX/$j/
cd ../../../../sh/
echo current directory to = $(pwd)
done
# 
echo all failure/success checks are completed
echo exporting total number of lammps instance encountered extrapolation = $sumfails to HDD as file -SUM-
echo "$sumfails">../tmp/SUM
echo file -SUM- is generated
echo closing file -checkfail.sh- 
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 