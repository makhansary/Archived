#!/bin/bash 
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
		rm myPOS
	sed -i '3s/.*/                15             0             0/' POSCAR
	sed -i '4s/.*/                0             15             0/' POSCAR
	sed -i '5s/.*/                0             0             15/' POSCAR