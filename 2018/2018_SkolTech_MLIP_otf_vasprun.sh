#!/bin/bash 
#SBATCH -N 1                
#SBATCH -n 16                
#SBATCH -t 120:00:00          
#SBATCH --mem-per-cpu=7675
echo ++++++++++++++++++++++++++++++++++++++++
echo vasprun.sh is open
echo submitting vasp job 
mpirun -np 16 /opt/vasp/bin/vasp5.4.1MPI
echo Job completed 
echo making a copy of outcar file as completion flag 
cp OUTCAR OUTCAR_copy
echo copied outcar file as OUTCAR_copy
echo vasprun.sh is closed 
echo ++++++++++++++++++++++++++++++++++++++++
# End 
