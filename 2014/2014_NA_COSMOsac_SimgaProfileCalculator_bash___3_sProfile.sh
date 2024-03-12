#!/bin/bash
#
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
# ...sProfile.sh...
# reads the COSMO data and generates the Sigma Profiles
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
#
runID=$(date --rfc-3339='date');
compound='75-85-4-2d';
#
segments=$(cat ${compound}.cosmo.segments);
EE=2.71828;
REFF=0.81764200000000;
REFF2=$(bc <<< "scale=8;$REFF*$REFF");
echo 'if you see following warning:'
echo '***************************************'
echo 'Runtime warning (func=(main), adr=22): non-zero scale in exponent'
echo '***************************************'
echo 'do not care, calculations are going on in any case'
echo 'this message disappeares after 20s'
sleep 20s
for i in `seq 1 $segments`
	do
	NormSum=0;
	SigmaNew=0;
	for j in `seq 1 $segments`
		do
		# reading data
		xi=`sed -n ${i}p ${compound}.cosmo.POSxA`;
		yi=`sed -n ${i}p ${compound}.cosmo.POSyA`;
		zi=`sed -n ${i}p ${compound}.cosmo.POSzA`;
		xj=`sed -n ${j}p ${compound}.cosmo.POSxA`;
		yj=`sed -n ${j}p ${compound}.cosmo.POSyA`;
		zj=`sed -n ${j}p ${compound}.cosmo.POSzA`;
		RADj=`sed -n ${j}p ${compound}.cosmo.RADau`;
		Sigma=`sed -n ${j}p ${compound}.cosmo.QperA`;
		diffx=$(bc <<< "scale=8;$xi - $xj");
		diffy=$(bc <<< "scale=8;$yi - $yj");
		diffz=$(bc <<< "scale=8;$zi - $zj");
		Dist=$(bc <<< "scale=8;$diffx*$diffx + $diffy*$diffy + $diffz*$diffz");
		sqrDist=$(bc <<< "scale=8;sqrt($Dist)");
		RADj2=$(bc <<< "scale=8;$RADj*$RADj");
		mRADjREFF=$(bc <<< "scale=8;$RADj2*$REFF2");
		pRADjREFF=$(bc <<< "scale=8;$RADj2 + $REFF2");
		mpRADjREFF=$(bc <<< "scale=8;$mRADjREFF/$pRADjREFF");
		DistpRADjREFF=$(bc <<< "scale=8;$Dist/$pRADjREFF");
		Expt=$(bc <<< "scale=8;$DistpRADjREFF");
		Expt=`echo "$EE^$Expt" | bc -l`;
		Expt=`echo "1/$Expt" | bc -l`;
		SigmaSum=$(bc <<< "scale=8;$Sigma*$mpRADjREFF*$Expt");
		NormDist=$(bc <<< "scale=8;$mpRADjREFF*$Expt");
		NormSum=$(bc <<< "scale=8;$NormSum + $NormDist");
		SigmaNew=$(bc <<< "scale=8;$SigmaNew + $SigmaSum");
		clear;
	done
	SigmaNonSrt=$(bc <<< "scale=8;$SigmaNew/$NormSum");
	echo  $SigmaNonSrt >> ${compound}.cosmo.SigmaProfileNonSrt;
done
# all done -  now exiting ...
#
