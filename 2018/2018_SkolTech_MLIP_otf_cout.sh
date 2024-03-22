#!/bin/bash
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo file -count.sh- is open .... 
echo current directory = $(pwd)
echo on server $(hostname)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle
echo -NOTE- MLIP generates POSCAR starting by 0	like POSCAR0 in the case of more than one extrapolated configuration 
echo start counting number of POSCAR file in directory ../runs/$cycle/mlip/POSCAR/ 
echo entering directory ../runs/$cycle/mlip/POSCAR/
cd ../runs/"$cycle"/mlip/POSCAR/
echo current directory = $(pwd)
echo start counting ..... 
find . -type f | wc -l > s
nn=$(cat "s")
n=`expr "$nn" - 1`
echo total number of POSCAR files = $n
rm s
echo leaving directory ../runs/$cycle/mlip/POSCAR/ 
cd ../../../../sh/
echo current directory = $(pwd)
echo exporting number of POSCAR files into HDD as file -N- 
echo "$n" > ../tmp/N 
echo  file -N- is generated
echo closing file count.sh 
echo ++++++++++++++++++++++++++++++++++++++++
# end of file