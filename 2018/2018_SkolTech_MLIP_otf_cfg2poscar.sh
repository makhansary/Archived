#!/bin/bash
# 
echo ++++++++++++++++++++++++++++++++++++++++
echo cfg2poscar.sh file is open .... 
echo current directory = $(pwd)
echo on server $(hostname)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle 
echo executing MLIP convert command for CFG 2 POSCAR 
../src/mlip/mlp convert-cfg ../runs/"$cycle"/mlip/trainset.cfg ../runs/"$cycle"/mlip/POSCAR/POSCAR --output-format=vasp-poscar --elements-order=0
echo executed MLIP convert command
echo POSCAR files are generated at ../runs/$cycle/mlip/POSCAR/
echo closing cfg2poscar.sh file
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 