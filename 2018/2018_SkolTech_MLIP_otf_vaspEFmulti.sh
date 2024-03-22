#!/bin/bash
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo file -vaspEFmulti.sh- is open ....
echo current directory = $(pwd)
echo on server $(hostname) 
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
i=$(cat ../tmp/"I")
ii=`expr "$i" - 1`
mode=$(cat ../usr/"MODE")
echo ++++++++++++++++++++++++++++++++++++++++ 
echo creating directory in ../runs/$cycle/vaspEF/$i/ for vaspEFrun=$i
mkdir ../runs/"$cycle"/vaspEF/"$i"/
echo directory is created at ../runs/$cycle/vaspEF/$i/
echo copying POSCAR from ../runs/$cycle/mlip/POSCAR/POSCAR$ii to ../runs/$cycle/vaspEF/$i/POSCAR
cp ../runs/"$cycle"/mlip/POSCAR/POSCAR"$ii" ../runs/"$cycle"/vaspEF/"$i"/POSCAR
echo POSCAR file copied from ./runs/$cycle/mlip/POSCAR/POSCAR$ii to ../runs/$cycle/vaspEF/$i/POSCAR
echo getting vaspEF required files ready for run=$i in cycle=$cycle
echo copying INCAR and POTCAR files from: ../src/vaspEF/ echo to ../runs/$cycle/vaspEF/$i/
cp ../src/vaspEF/* ../runs/"$cycle"/vaspEF/"$i"/
echo INCAR and POTCAR files coped from: ../src/vaspEF/ echo to ../runs/$cycle/vaspEF/$i/
echo copying -vasprun.sh- from: ../sh/vasprun.sh echo to ../runs/$cycle/vaspEF/$i/
cp ../sh/vasprun.sh ../runs/"$cycle"/vaspEF/"$i"/
echo copied -vasprun.sh- from: ../sh/vasprun.sh echo to ../runs/$cycle/vaspEF/$i/
echo entering directory ../runs/$cycle/vaspEF/$i/
cd ../runs/"$cycle"/vaspEF/"$i"/
echo current directory to = $(pwd)
echo ++++++++++++++++++++++++++++++++++++++++
if [ "$mode" -eq "2" ]; then
	echo obtained POSCAR file needs modification in Learning by Neighborhood task --mode=2-- 
	sed -i '3s/.*/                25             0             0/' POSCAR
	sed -i '4s/.*/                0             25             0/' POSCAR
	sed -i '5s/.*/                0             0             25/' POSCAR
fi
echo ++++++++++++++++++++++++++++++++++++++++
echo leaving directory ../runs/$cycle/vaspEF/$i/
cd ../../../../sh/
echo current directory = $(pwd)
echo closing file -vaspEFmulti.sh- 
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 