#!/bin/bash
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
# ...Dmol3OUTMOL.sh...
# reads the OUTMOL files generated by DMol3 module
# and returns QM data as required by COSMO-based models
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
# Extracting data domain to export QM data
# - detecting line number for -cosmo information- section of OUTMOL file
#
runID=$(date --rfc-3339='date');
compound='75-85-4-2d';
#
line=`grep -n 'COSMO Results' ${compound}.outmol`;
line=`echo $line | sed -e 's/:.*//'`;
RESstarts=$(($line + 10));
RESends=$(($RESstarts + 4));
# reading QM data and writing to file
for L in `seq $RESstarts $RESends`;
	do
	data=`sed -n ${L}p ${compound}.outmol`;
	echo  $data >> ${compound}.outmol.QMdata;
done
# export completed to .QMdata file
sed '${/^[[:space:]]*$/d}' ${compound}.outmol.QMdata > out;
mv out ${compound}.outmol.QMdata;
# - writing individual QM data to scatter files
sCavgAU=`sed -n 1p ${compound}.outmol.QMdata`;
sCavgAU=`echo $sCavgAU | sed -e 's/.*= //'`;
echo  $sCavgAU >> ${compound}.outmol.sCavgAU;
vAU=`sed -n 2p ${compound}.outmol.QMdata`;
vAU=`echo $vAU | sed -e 's/.*= //'`;
echo  $vAU >> ${compound}.outmol.vAU;
sCavgA=`sed -n 3p ${compound}.outmol.QMdata`;
sCavgA=`echo $sCavgA | sed -e 's/.*= //'`;
echo  $sCavgA >> ${compound}.outmol.sCavgA;
vA=`sed -n 4p ${compound}.outmol.QMdata`;
vA=`echo $vA | sed -e 's/.*= //'`;
echo  $vA >> ${compound}.outmol.vA;
#
#mkdir $runID
#mv *.outmol.* $runID/
# all done -  now exiting ...
#