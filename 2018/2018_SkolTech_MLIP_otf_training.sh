#!/bin/bash
#
echo ++++++++++++++++++++++++++++++++++++++++
echo file -training.sh- is open ....
echo current directory = $(pwd)
echo reading file CYCLE 
cycle=$(cat ../tmp/"CYCLE")
echo cycle is $cycle
dummy=$(($cycle-1))
echo getting files ready for training ..... 
echo ++++++++++++++++++++++++++++++++++++++++
echo start training MTP from ../runs/$cycle/mlip/curr.mtp to CFG in ../runs/$cycle/mlip/trainset.cfg
echo -------------------------------------
echo copying trainrun.sh into cycle = $cycle mlip directory ../runs/$cycle/mlip
cp trainrun.sh ../runs/"$cycle"/mlip
echo trainrun.sh copied to ../runs/$cycle/mlip
echo copying last updated -curr.mtp- from ../runs/$dummy/mlip to ../runs/$cycle/mlip
cp ../runs/"$dummy"/mlip/curr.mtp ../runs/"$cycle"/mlip/curr.mtp
echo last updated -curr.mtp- copied from ../runs/$dummy/mlip to ../runs/$cycle/mlip
echo entering this cycle = $cycle mlip directory ../runs/$cycle/mlip
cd ../runs/"$cycle"/mlip
echo current directory to = $(pwd)
echo ++++++++++++++++++++++++++++++++++++++++
echo launching MPI command
echo making a backup of -curr.mtp- as -curr.mpt_bckup-
cp curr.mtp curr.mtp_bckup
echo made a backup of -curr.mtp- as -curr.mpt_bckup-
echo ++++++++++++++++++++++++++++++++++++++++
#echo determining the min distance in -trainset.cfg- and modifying the respective line in -curr.mtp file 
#./mlp mindist trainset.cfg > dmin
#Dmin=$(cat "dmin")
#minD=${Dmin//[!0-9.]/}
#echo min distance is -$minD- 
#echo modifying -curr.mtp- for rmin value
#sed -i '8s/.*/min_dist =  '$minD'/' curr.mtp
#echo -curr.mtp- file is updated
#echo ++++++++++++++++++++++++++++++++++++++++
echo executing MPI command
mpirun -np 46 ../../../src/mlip/mlp train curr.mtp trainset.cfg --max-iter=1000 --stress-weight=0 --curr-pot-name=curr.mtp --trained-pot-name=curr.mtp  --auto-min-dist
echo making a copy of -curr.mtp- as completion flag 
cp curr.mtp curr.mtp_copy
echo a copy of curr.mtp is created as curr.mtp_copy
echo training  tasks completed
echo closing file -trainrun.sh-
echo ++++++++++++++++++++++++++++++++++++++++
echo leaving ../runs/$cycle/mlip
cd ../../../sh/
echo current directory = $(pwd)
echo training job submitted
echo closing file -training.sh-  
echo ++++++++++++++++++++++++++++++++++++++++
# end of file 