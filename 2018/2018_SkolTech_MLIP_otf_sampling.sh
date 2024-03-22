#!/bin/bash
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo file -sampling.sh- is open .....
echo current directory = $(pwd)
echo on server $(hostname)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
dummy=$(($cycle-1))
echo previous run number is $dummy
echo reading file MODE to detect mode  
mode=$(cat ../usr/"MODE")
echo mode is $mode
echo ++++++++++++++++++++++++++++++++++++++++
echo Sample extrapolated configurations echo from file located in ../runs/$dummy/mlip/selected.cfg
echo using MTP located in ../runs/$dummy/mlip/curr.mtp and writing to ../runs/$cycle/mlip/sampled.cfg
echo ++++++++++++++++++++++++++++++++++++++++
echo entering directory ../runs/$cycle/mlip/
cd ../runs/"$cycle"/mlip/
echo current directory = $(pwd)
echo make a directory -sampled- to move all sample.cfg files into 
mkdir sampled 
echo created directory -sampled- 
echo launching MLIP 
#
mpirun -n 46 ../../../src/mlip/mlp_A select-add ../../"$dummy"/mlip/curr.mtp ../../"$dummy"/mlip/trainset.cfg  ../../"$dummy"/mlip/selected.cfg sampled.cfg --mvs-filename=../../"$dummy"/mlip/state.mvs  --weighting=structures  --nbh-weight=1  --energy-weight=0
cp sampled.* sampled/ 
echo moved all sampled.cfg_ files into directory -sampled- 
rm sampled.*
cd sampled/ 
find . -type f | wc -l > s
z=$(cat "s")
z=`expr "$z" - 1`
echo total number of POSCAR files = $z
cd ..
#
echo appending all to -sampled.cfg- file at ../runs/$cycle/mlip/ 
z=`expr "$z" - 1` # shifting 
if [ "$z" -gt "1" ]; then
	for i in `seq 0 $z`;
		do
		echo appending sampled.cfg_$i
		cat sampled/sampled.cfg_$i >> sampled.cfg
	done
else 
	cp sampled/sampled.cfg sampled.cfg
fi 
#####################
#if [ "$mode" -eq "2" ]; then 
#	echo copy -curr.mtp- to from ../../$dummy/mlip/curr.mtp to ../runs/$cycle/mlip/ 
#	cp ../../"$dummy"/mlip/curr.mtp curr.mtp 
#	echo copied -curr.mtp- to from ../../$dummy/mlip/curr.mtp to ../runs/$cycle/mlip/ 
#	if [ "$cycle" -gt "1" ]; then
#		echo using ../../../src/mlip/NeighDiff2.ini
#		echo retreiving previous -state.mvs- file from ../../$dummy/mlip/state.mvs to $(pwd)/state.mvs
#		cp ../../$dummy/mlip/state.mvs state.mvs
#		echo copied  previous -state.mvs- file from ../../$dummy/mlip/state.mvs to $(pwd)/state.mvs
#		mpirun -np 16 ../../../src/mlip/mlp make-mvs ../../../src/mlip/NeighDiff2.ini --cfg-filename=../../$dummy/mlip/selected.cfg
#	else 
#		echo using ../../../src/mlip/NeighDiff1.ini
#		mpirun -np 16 ../../../src/mlip/mlp make-mvs ../../../src/mlip/NeighDiff1.ini --cfg-filename=../../$dummy/mlip/selected.cfg
#	fi 
#	cp diff.* sampled/ 
#	echo copied all diff.cfg files into directory -sampled-
#	rm diff.*
#	echo removed-cleaned all diff.cfg files 
#	#
#	cd sampled/ 
#	find . -type f | wc -l > s
#	z=$(cat "s")
#	z=`expr "$z" - 1`
#	rm s
#	echo total number of diff.cfg files = $z
#	cd ..
#	#	
#	echo appending all to -diff.cfg- file at ../runs/$cycle/mlip/ 
#	z=`expr "$z" - 1` # shifting
#	if [ "$z" -gt "1" ]; then
#		for i in `seq 0 $z`;
#			do
#			echo appending sampled.cfg_$i
#			cat sampled/diff.cfg_$i >> sampled.cfg
#		done
#	else 
#		cp sampled/diff.c* >> sampled.cfg
#	fi 	
#else
#	mpirun -np 16 ../../../src/mlip/mlp select-add ../../"$dummy"/mlip/curr.mtp ../../"$dummy"/mlip/selected.cfg sampled.cfg --mvs-filename=../../"$dummy"/mlip/state.mvs
#	mv sampled.* sampled/ 
#	#
#	cd sampled/ 
#	find . -type f | wc -l > s
#	z=$(cat "s")
#	z=`expr "$z" - 1`
#	echo total number of POSCAR files = $z
#	cd ..
#	#
#	echo moved all sampled.cfg_ files into directory -sampled- 
#	echo appending all to -sampled.cfg- file at ../runs/$cycle/mlip/ 
#	z=`expr "$z" - 1` # shifting 
#	if [ "$z" -gt "1" ]; then
#		for i in `seq 0 $z`;
#			do
#			echo appending sampled.cfg_$i
#			cat sampled/sampled.cfg_$i >> sampled.cfg
#		done
#	else 
#		cp sampled/sampled.cfg sampled.cfg
#	fi 
#fi 
#
echo leaving directory ../runs/$cycle/mlip/
cd ../../../sh/ 
echo current directory = $(pwd)
echo closing file -sampling.sh- 
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 