#!/bin/bash
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo file -vaspEFmulti.sh- is open ....
echo on server $(hostname) 
echo current directory = $(pwd)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
i=$(cat ../tmp/"I")
mode=$(cat ../usr/"MODE")
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo creating directory in ../runs/$cycle/vaspEF/$i/ for vaspEFrun=$i
mkdir ../runs/"$cycle"/vaspEF/"$i"/
echo directory is created at ../runs/$cycle/vaspEF/$i/
echo copying vasprun.sh to ../runs/$cycle/vaspEF/$i/
cp vasprun.sh ../runs/$cycle/vaspEF/$i/
echo copied vasprun.sh to ../runs/$cycle/vaspEF/$i/
echo copying POSCAR from: ../runs/$cycle/mlip/POSCAR/POSCAR to ../runs/$cycle/vaspEF/$i/POSCAR
cp ../runs/"$cycle"/mlip/POSCAR/POSCAR ../runs/"$cycle"/vaspEF/"$i"/POSCAR
echo POSCAR file copied from ../runs/$cycle/mlip/POSCAR/POSCAR to ../runs/$cycle/vaspEF/$i/POSCAR
echo getting vaspEF required files ready for run=$i in cycle=$cycle
echo copying INCAR and POTCAR files from: ../src/vaspEF/ echo to ../runs/$cycle/vaspEF/$i/
cp ../src/vaspEF/* ../runs/"$cycle"/vaspEF/"$i"/
echo INCAR and POTCAR files coped from: ../src/vaspEF/ echo to ../runs/$cycle/vaspEF/$i/
echo copying -vasprun.sh- from: ../sh/vasprun.sh echo to ../runs/$cycle/vaspEF/$i/
cp ../sh/vasprun.sh ../runs/"$cycle"/vaspEF/"$i"/
echo copied -vasprun.sh- from: ../sh/vasprun.sh echo to ../runs/$cycle/vaspEF/$i/
echo entering directory ../runs/$cycle/vaspEF/$i/
cd ../runs/"$cycle"/vaspEF/"$i"/
echo current directory = $(pwd)
echo ++++++++++++++++++++++++++++++++++++++++
if [ "$mode" -eq "2" ]; then
	echo obtained POSCAR file needs modification in Learning by Neighborhood task --mode=2-- 
	sed -i '3s/.*/                15             0             0/' POSCAR
	sed -i '4s/.*/                0             15             0/' POSCAR
	sed -i '5s/.*/                0             0             15/' POSCAR
		list=$(cat POSCAR)
		data=0;
		for item in ${list//\ / }; 
			do 
				data=$(($data+1)); 
				echo  $item >> myPOS; 
		done
		ex -sc '1d14|x' myPOS 
		iter=1
		while [ $((3*$iter)) -lt $data ]
			do
				x=$(($iter*3-2));
				y=$(($iter*3-1));
				z=$(($iter*3));
				lX=`sed -n ${x}p myPOS`; 
				lY=`sed -n ${y}p myPOS`;
				lZ=`sed -n ${z}p myPOS`;
				X=`echo "$lX + 5" | bc -l`
				Y=`echo "$lY + 5" | bc -l`
				Z=`echo "$lZ + 5" | bc -l`
				line=$((8+$iter));				
				`sed -i "${line}s/.*/                $X             $Y             $Z/" POSCAR`
				iter=$(($iter+1));
				clear;
		done
fi
echo ++++++++++++++++++++++++++++++++++++++++
echo leaving directory ../runs/$cycle/vaspEF/$i/
cd ../../../../sh/
echo current directory = $(pwd)
echo closing file -vaspEFsingle.sh- 
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 