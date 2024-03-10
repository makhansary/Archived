#!/bin/bash
# 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
# ...SortS.sh...  
# reads and sorts the Sigma Profiles 
# +++++++++++++++++++++++++++++++++++++++++++++++++++++
ITER=51; 
for i in `seq 1 $ITER`
	do 
	j=$(($i-1));
	SigmaSrt=$((-0.025+0.001*$j)); 
	echo $SigmaSrt >> ${compound}.cosmo.SigmaSrt; 
	echo 0 >> ${compound}.cosmo.PSigmaSrt; 
done 
segments=$(cat ${compound}.cosmo.segments);
segmentnum=${segments//\ / };
for j in `seq 1 $segmentnum`
	do 
	Aau=`sed -n ${j}p ${compound}.cosmo.Aau`;
	SigmaNonSrtJ=`sed -n ${j}p ${compound}.cosmo.SigmaNonSrt`;
	SigmaSrt1=`sed -n ${1}p ${compound}.cosmo.SigmaSrt`;
	TMP=$(($SigmaNonSrtJ - $SigmaSrt1));
	TMP=$(($TMP/0.001)); 
	TMP=$((floor($TMP))); 
	TMP1=$(($TMP + 1));
	TMP2=$(($TMP + 2));
	SPTMP1=`sed -n ${TMP1}p ${compound}.cosmo.PSigmaSrt`;
	SPTMP2=`sed -n ${TMP2}p ${compound}.cosmo.PSigmaSrt`;
	Term1=$(($SigmaNonSrtJ-$SPTMP1));
	Term2=$(($Aau*$Term1));
	Term3=$(($Term2/0.001)); 
	SP2=$(($SPTMP2+$Term3));
	Term4=$(($SPTMP2-$SigmaNonSrtJ));
	Term5=$(($Aau*$Term4)); 
	Term6=$(($Term5/0.001));
	SP1=$(($SPTMP1+$Term6));
	`sed -i "${TMP1}s/.*/$SP1/" ${compound}.cosmo.PSigmaSrt`
	`sed -i "${TMP2}s/.*/$SP2/" ${compound}.cosmo.PSigmaSrt`
done	
# cleaning ... 
# nothing to clean 
# all done -  now exiting ...
#