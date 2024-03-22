#!/bin/bash
#
echo ++++++++++++++++++++++++++++++++++++++++
echo file genMVS is open
echo current directory = $(pwd)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle
echo reading file MODE to detect mode  
mode=$(cat ../usr/"MODE")
echo mode is $mode
echo ++++++++++++++++++++++++++++++++++++++++
echo entering ../runs/$cycle/mlip
cd ../runs/"$cycle"/mlip
echo current directory = $(pwd)
#if [ "$mode" -eq "2" ]; then  
#	echo detected mode = updating MTP for extended system based on LEARNING by NEIGHBORHOOD with OTFAL 
#	echo using special binary .ini file 
#	#../../../src/mlip/mlp make-mvs ../../../src/mlip/NeighMVS.ini --cfg-filename=trainset.cfg
#	echo replaced command --- by Alex ...
#	../../../src/mlip/mlp select-add curr.mtp trainset.cfg trainset.cfg tempINmvs.cfg --weighting=structures --mvs-filename=new_state.mvs --nbh-weight=1  --energy-weight=0
#else
#	echo in order to generate -state.mvs- file
#	echo use trained MTP file at ../runs/$cycle/mlip/curr.mtp and CFG file at ../runs/$cycle/mlip/trainset.cfg
#	echo launching MLIP select-add command 
#	../../../src/mlip/mlp select-add curr.mtp trainset.cfg tempINmvs.cfg
#	#../../../src/mlip/mlp-new select-add curr.mtp trainset.cfg trainset.cfg tempINmvs.cfg --weighting=structures --mvs-filename=new_state.mvs
#fi 
#
../../../src/mlip/mlp_A select-add curr.mtp trainset.cfg trainset.cfg tempINmvs.cfg --mvs-filename=new_state.mvs --weighting=structures --nbh-weight=1 --energy-weight=0
#
#: ./mlp run mlip.ini --filename=trainset.cfg  
while [ ! -f new_state.mvs ]
	do
		sleep 30s
done
echo executed MLIP command
echo file -new_state.mvs- is generated
echo renaming -state.mvs- to -state_old.mvs-
mv state.mvs state_old.mvs
echo renaming -new_state.mvs- to -state.mvs-
mv new_state.mvs state.mvs
echo leaving directory ../runs/$cycle/mlip
cd ../../../sh/ 
echo current directory changed to = $(pwd)
echo closing file genMVS.sh 
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 