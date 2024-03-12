#!/bin/bash
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
# ...Dmol3COSMO.sh..
# reads the COSMO files generated by DMol3 module
# and returns QM data as required by COSMO-based models
# it also performs unit conversion
# from -atomic unit- to -Angstrom-
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
# Extracting data domain to export QM data
#
runID=$(date --rfc-3339='date');
compound='75-85-4-2d';
#
PI=3.14159265358979;
AU2A=0.529177249;
# - detecting line number for -segment information- section of COSMO file
line=`grep -n 'segment information' ${compound}.cosmo`;
line=`echo $line | sed -e 's/:.*//'`;
QMstart=${line};
QMstarts=$(($QMstart + 3));
# - detecting number of segments
line=`grep -n 'total number of segments' ${compound}.cosmo`;
line=`echo $line | sed -e 's/.*= //'`;
segmentnum=`echo "${line//[^0-9]/}"`
echo $segmentnum > ${compound}.cosmo.segments
#
QMends=$(($segmentnum + $QMstarts));
# reading QM data and writing to file
for L in `seq $QMstarts $QMends`;
	do
	QMdata=`sed -n ${L}p ${compound}.cosmo`;
	echo  $QMdata >> ${compound}.cosmo.QMdata;
done
# export completed to .QMdata file
sed '${/^[[:space:]]*$/d}' ${compound}.cosmo.QMdata > out;
mv out ${compound}.cosmo.QMdata;
# - writing individual QM data to scatter files
while read idx nidx POSxAU POSyAU POSzAU Q Aau QperA POTau
	do
	echo  $POSxAU >> ${compound}.cosmo.POSxAU;
	POSxA=$(bc <<< "scale=6;$POSxAU*$AU2A");
	echo  $POSxA >> ${compound}.cosmo.POSxA;
	echo  $POSyAU >> ${compound}.cosmo.POSyAU;
	POSyA=$(bc <<< "scale=6;$POSyAU*$AU2A");
	echo  $POSyA >> ${compound}.cosmo.POSyA;
	echo  $POSzAU >> ${compound}.cosmo.POSzAU;
	POSzA=$(bc <<< "scale=6;$POSzAU*$AU2A");
	echo  $POSzA >> ${compound}.cosmo.POSzA;
	echo  $Q >> ${compound}.cosmo.Charges;
	echo  $Aau >> ${compound}.cosmo.Aau;
	AA=$(bc <<< "scale=6;$Aau*$AU2A*$AU2A");
	echo  $AA >> ${compound}.cosmo.AA;
	RADau=$(bc <<< "scale=6;$Aau/$PI");
	RADau=$(bc <<< "scale=6;sqrt($RADau)");
	#RADau=$(bc <<< "scale=6;sqrt($(($Aau/$PI)))");
	echo  $RADau >> ${compound}.cosmo.RADau;
	RADA=$(bc <<< "scale=6;$RADau*$AU2A");
	echo  $RADA >> ${compound}.cosmo.RADA;
	echo  $QperA >> ${compound}.cosmo.QperA;
	echo  $POTau >> ${compound}.cosmo.POTau;
done<${compound}.cosmo.QMdata
cp ${compound}.cosmo.QperA ${compound}.cosmo.SigmaDensity
#
#mkdir $runID
#mv *.cosmo.* $runID/
# all done -  now exiting ...
#