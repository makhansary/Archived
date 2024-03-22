#!/bin/bash
echo ++++++++++++++++++++++++++++++++++++++++
echo file -MAIN.sh- is open ....
echo on server $(hostname)
echo current directory = $(pwd)
echo ++++++++++++++++++++++++++++++++++++++++
echo setting training flag 
cycleF=1 # flag for training -1= needed-0=not needed
echo training flag is set as $cycleF --  1= needed-0=not needed
echo ++++++++++++++++++++++++++++++++++++++++
echo reading USER settings from directory -usr- 
echo reading default values and exporting to directory tmp
echo reading total number of lammps dynamic runs -m-
m=$(cat ../usr/"M")
cp ../usr/"M" ../tmp/
echo m is $m 
echo reading file TERMINATION for soft terminating - cycles cannot exceed it 
termination=$(cat ../usr/"TERMINATION")
echo runs will stop if the cycle exceeds -$termination- 
echo to increase or decrease this value modify file TERMINATION in default directory
echo detecting debug mode status 
debug=$(cat ../usr/"DEBUG")
echo debug mode = $debug -on=1-off=0-
echo detecting task mode 
mode=$(cat ../usr/"MODE")
echo mode is $mode -0=genMTP-1=ExtSys-2=Neigh-
echo reading file MAINPATH 
mainpath=$(cat ../usr/"MAINPATH")
echo main directory path is $mainpath  
echo ++++++++++++++++++++++++++++++++++++++++
echo reading file SCRATCHPATH 
scratchpath=$(cat ../usr/"SCRATCHPATH")
echo main directory path is $scratchpath  
echo ++++++++++++++++++++++++++++++++++++++++
echo reading file TERMINATED 
cont=$(cat ../usr/"TERMINATED")
echo a previosuly terminated run state = $cont 
echo ++++++++++++++++++++++++++++++++++++++++
echo determining the dropped cycle
if [ "$cont" -eq "1" ]; then 
	cycle=$(cat ../tmp/"CYCLE")
	echo previously dropped cycle = cycle $cycle
else
	echo no previously dropped cycle is set 
	cycle=0 # training cycles counter 
	echo "$cycle" > ../tmp/CYCLE
	echo creating directory: ../runs in parent directory 
	mkdir ../runs
	echo created directory: ../runs 
fi
echo ++++++++++++++++++++++++++++++++++++++++
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
if [ "$debug" -eq "1" ]; then
echo debug mode is ON - user interactions is requested 
echo enetring main-global loop 
echo press a key to continue 
read 
while [ "$cycleF" -eq "1" ]
do
	echo file is open on server $(hostname)
	echo the cycle flag is set as $cycleF
	echo ++++++++++++++++++++++++++++++++++++++++
	echo determining cycle 
	cycle=$(cat ../tmp/"CYCLE")
	echo cycle=$cycle
	echo ++++++++++++++++++++++++++++++++++++++++
	echo checking the cycles soft termination state 
	if [ "$cycle" -gt "$termination" ]; then
		echo cycle exceeds $termination - terminating ...
		break
	fi
	echo cycles soft termination is NOT exceeded yet 
	echo ++++++++++++++++++++++++++++++++++++++++
	echo creating cycle directories under -runs- directory 
	echo on server $(hostname)
	echo press a key to continue 
	read 
	echo creating directory: ../runs/$cycle/
	mkdir ../runs/"$cycle"/
	echo creating directory:../runs/$cycle/vaspEF/
	mkdir ../runs/"$cycle"/vaspEF/
	echo creating directory: ../runs/$cycle/mlip/
	mkdir ../runs/"$cycle"/mlip/
	echo creating directory: ../runs/$cycle/mlip/POSCAR/
	mkdir ../runs/"$cycle"/mlip/POSCAR/
	echo ++++++++++++++++++++++++++++++++++++++++
	# assuming always drops start with lammps re-activation .... 
	if [ "$cont" -eq "0" ]; then
		echo ++++++++++++++++++++++++++++++++++++++++
		if [ "$cycle" -eq "0" ]; then
			echo cycle is $cycle 
			echo ++++++++++++++++++++++++++++++++++++++++
			if [ "$mode" -eq "2" ]; then
				echo detected mode = updating MTP for extended system based on LEARNING by NEIGHBORHOOD with OTFAL
				echo press a key to continue 
				read 
				echo copying -curr.mtp- from tmp/ to runs/$cycle/mlip/
				echo initial LAMMPS runs do not need -state.mvs- file 
				echo see .ini files for more info 
				echo all the extrapolated configurations will be used as trainset after selection using -curr.mtp- file
				cp ../tmp/curr.mtp ../runs/"$cycle"/mlip/
				echo file -curr.mtp- copied  
			fi
			echo ++++++++++++++++++++++++++++++++++++++++
		else 
			echo cycle is $cycle 
			echo ++++++++++++++++++++++++++++++++++++++++
			echo preparing to detect extrapolated CFGs from previous run and sample them 
			echo press a key to continue 
			read 
			./sampling.sh
			echo entering directory ../runs/$cycle/mlip/
			cd ../runs/"$cycle"/mlip/ 		
			while [ ! -f "sampled.cfg" ]
				do
					sleep 30s
			done
			echo executed sampling of extrapoltaed configurations
			echo sampling is completed 
			echo ++++++++++++++++++++++++++++++++++++++++
			echo cleaning .... 
			dummy=$(($cycle-1))
			#echo a dummy -new_state.mvs- is generated - renaming it to -new_state_dummy.mvs- 
			#mv new_state.mvs new_state_dummy.mvs
			#echo renamed -new_state.mvs- file to -new_state_dummy.mvs- 
			echo creating a backup of sampled.cfg as sampled_old.cfg 
			cp sampled.cfg sampled_old.cfg
			echo created a backup of sampled.cfg as sampled_old.cfg
			echo creating new trainset from sampled.cfg 
			mv sampled.cfg trainset.cfg
			echo renamed sampled.cfg to trainset.cfg
			echo new trainset is generated as trainset.cfg
			echo leaving directory ../runs/$cycle/mlip/
			cd ../../../sh/ 
			echo current directory = $(pwd)
			echo ++++++++++++++++++++++++++++++++++++++++
			echo start generating POSCAR files from trainset.cfg
			echo press a key to continue 
			read 
			./cfg2poscar.sh
			echo ++++++++++++++++++++++++++++++++++++++++
			echo deleting -trainset.cfg- file without E and F - 
			echo which is the sampled from extrapolated cfgs -../runs/$cycle/mlip/trainset.cfg- 
			rm ../runs/"$cycle"/mlip/trainset.cfg 
			echo deleted trainset.cfg file without E and F -../runs/$cycle/mlip/trainset.cfg-		
			echo ++++++++++++++++++++++++++++++++++++++++
			echo start counting POSCAR files located in ../runs/$cycle/mlip/POSCAR/
			echo press a key to continue 
			read 
			./cout.sh
			echo ++++++++++++++++++++++++++++++++++++++++
			echo preparing to launch vaspEF runs
			echo press a key to continue 
			read 
			n=$(cat ../tmp/"N")
			echo number of vaspEF runs is set to n=$n 
			echo preparing directories and files for vaspEF runs ...  
			echo press a key to continue 
			read 
			for i in `seq 1 $n`;
					do
				if [ "$n" -gt "1" ]; then
					echo more than 1 extrapolated configuration is detected - opening vaspEFmulti.sh file 
					echo "$i" > ../tmp/I
					./vaspEFmulti.sh
					
				else
					echo only 1 extrapolated configuration is detected - opening vaspEFsingle.sh file
					echo "$i" > ../tmp/I
					./vaspEFsingle.sh
				fi 
			done
			echo ++++++++++++++++++++++++++++++++++++++++ 
			echo preparing to migrate to 10.30.16.62 server to launch vaspEF runs
			echo press a key to continue 
			read
			echo copying vaspEF directory from ../runs/$cycle/vaspEF/ on $(hostname) to 10.30.16.62 server
			echo starting copy process ... 
			scp -i ~/.ssh/id_rsa -r ../runs/$cycle/vaspEF mkhansary@10.30.16.62:/home/mkhansary/ 	
			echo finished copy 
			echo files on 10.30.16.62 server are ready for vaspEF runs ...
			echo press a key to continue 
			read
			echo ++++++++++++++++++++++++++++++++++++++++
			for i in `seq 1 $n`;
				do
				echo "$i" > ../tmp/I
				scp -i ~/.ssh/id_rsa ../tmp/I mkhansary@10.30.16.62:/home/mkhansary/
				scp -i ~/.ssh/id_rsa ../tmp/CYCLE mkhansary@10.30.16.62:/home/mkhansary/
				echo remembering where we were on $(hostname)
				path61=$(pwd)
				echo migrating to 62 
				ssh -i ~/.ssh/id_rsa mkhansary@10.30.16.62 
				echo moved to server $(hostname)
				cycle=$(cat CYCLE)
				echo cycle = $cycle 
				i=$(cat I)
				echo i = $i
				echo submitting jobs ... 
				echo entering directory vaspEF/$i/
				cd vaspEF/$i/ 
				echo $(pwd) on $(hostname)
				echo submitting Slurm for vaspEF run $i
				sbatch -x node-mmm01 -J vaspEF"$i" -N 1 -o vaspEF."$cycle"."$i".out -e vaspEF."$cycle"."$i".err -p MMM ./vasprun.sh
				echo submitted to Slurm for vaspEF run $i
				echo moving back to parent directory
				cd ../../ 
				echo moved to $(pwd) on $(hostname)
				echo migrating to 61 
				ssh -i ~/.ssh/id_rsa mkhansary@10.30.16.61
				cd "$path61"
				echo $(pwd) 
			done
			echo ++++++++++++++++++++++++++++++++++++++++
			echo we are back on $(hostname) - should be 61 
			echo press a key to continue 
			read
			echo all vaspEF runs are submitted on 10.30.16.62 server 
			echo we are about to migrate to 10.30.16.62 server to monitor vaspEF progress 
			echo press a key to continue 
			read
			for i in `seq 1 $n`;
				do
				echo "$i" > ../tmp/I
				scp -i ~/.ssh/id_rsa ../tmp/I mkhansary@10.30.16.62:/home/mkhansary/
				scp -i ~/.ssh/id_rsa ../tmp/CYCLE mkhansary@10.30.16.62:/home/mkhansary/
				echo remembering where we were on $(hostname) - should report 61 
				path61=$(pwd)
				echo migrating to 62 
				ssh -i ~/.ssh/id_rsa mkhansary@10.30.16.62 
				echo moved to server $(hostname) - should be 62 
				echo reminding -i- to 62
				i=$(cat I)
				echo i = $i
				cycle=$(cat CYCLE)
				echo cycle = $cycle
				echo monitoring vaspEF runs progress 
				echo enterning directory /vaspEF/$i/ and looking for file OUTCAR_copy
				cd /vaspEF/"$i"/
				echo current directory = $(pwd) on $(hostname) - should be 62
				while [ ! -f "OUTCAR_copy" ]
					do
						sleep 30s
				done
				echo  file OUTCAR_copy detected in vaspEF/$i/
				echo vaspEF$i completed
				echo moving back to parent directory
				cd ../../
				echo moved to $(pwd) on $(hostname)
				echo migrating to 61 
				ssh -i ~/.ssh/id_rsa mkhansary@10.30.16.61
				cd "$path61"
				echo $(pwd)
			done
			echo all vaspEF runs finished
			echo we are on $(hostname) - should report 61 
			echo press a key to continue 
			read
			echo ++++++++++++++++++++++++++++++++++++++++
			echo starting file transfer and then cleaning on 62 
			echo moving ../runs/$cycle/vaspEF to ../runs/$cycle/vaspEF_Pre
			mv ../runs/$cycle/vaspEF ../runs/$cycle/vaspEF_Pre
			echo moved ../runs/$cycle/vaspEF to ../runs/$cycle/vaspEF_Pre
			echo transfer ....
			echo press a key to continue 
			read
			echo remembering where we were on $(hostname) - should report 61
			path61=$(pwd)
			scp -i ~/.ssh/id_rsa ../tmp/CYCLE mkhansary@10.30.16.62:/home/mkhansary/
			echo migrating to 62 
			echo press a key to continue 
			read
			ssh -i ~/.ssh/id_rsa mkhansary@10.30.16.62 
			echo moved to server $(hostname) - should be 62 
			cycle=$(cat CYCLE)
			echo cycle = $cycle
			echo will be transfered under directory cycle = $cycle 
			echo executing SCP command ... 	
			echo press a key to continue 
			read
			scp -i ~/.ssh/id_rsa -r vaspEF mkhansary@10.30.16.61
			echo vaspEF directory is copied under home directory on 61 
			echo cleaning vaspEF directory on 62 
			rm -r vaspEF
			echo removed vaspEF directory on 62
			echo migrating to 61 
			echo press a key to continue 
			read
			ssh -i ~/.ssh/id_rsa mkhansary@10.30.16.61
			echo server $(hostname) - should report 61 
			echo moving vaspEF from home to /$mainpath/runs/$cycle/
			mv vaspEF /$mainpath/runs/$cycle/
			echo moved vaspEF from home to /$mainpath/runs/$cycle/
			echo moving back to parent directory
			cd "$path61"
			echo $(pwd)
			echo vaspEF directory is retrieved from 62 
			echo press a key to continue 
			read
			echo ++++++++++++++++++++++++++++++++++++++++
			echo monitoring vaspEF runs progress for completion - kept from previous - it acts as confirmation 
			echo press a key to continue 
			read
			for i in `seq 1 $n`;
				do
				echo enterning directory ../runs/$cycle/vaspEF/$i/ and looking for file OUTCAR_copy
				cd ../runs/"$cycle"/vaspEF/"$i"/
				echo current directory changed to = $(pwd)
				while [ ! -f "OUTCAR_copy" ]
					do
						sleep 30s
				done
				echo  file OUTCAR_copy detected in ../runs/$cycle/vaspEF/$i/
				echo vaspEF$i completed
				echo leaving directory ../runs/$cycle/vaspEF/$i/
				cd ../../../../sh/
				echo current directory changed to = $(pwd)
			done
			echo all vaspEF runs finished
			echo ++++++++++++++++++++++++++++++++++++++++
			echo converting vasp OUTCARs to one appended-CFG file
			echo press a key to continue 
			read 
			./outcar2cfg.sh 	
			echo ++++++++++++++++++++++++++++++++++++++++
			############################################################
			echo checking the special case i.e. mode=2-cycle=1 where no pre-existing -state.mvs- and -trainset.cfg- exist in ../../"$dummy"/mlip/
			echo press a key to continue 
			read 
			skip=0
			echo skip is set as $skip - default - performing files backup
			if [ "$mode" -eq "2" ]; then
				if [ "$cycle" -eq "1" ]; then
					echo mode is $mode and cycle is $cycle - 
					echo for this special case no pre-existing -state.mvs- and -trainset.cfg- exist in ../../"$dummy"/mlip/
					skip=1
					echo skip set as $skip - skipping files backup
				fi 
			fi 
			############################################################
			echo special case is checked and skip is set as $skip - continueing to trainset preparation ....
			echo press a key to continue 
			read 
			if [ "$skip" -eq "0" ]; then
				echo skip set as $skip - performing file backup
				echo press a key to continue 
				read 
				echo for data backup --- downloading -state.mvs- file from round $dummy to round $cycle mlip subdirectory 
				cp ../runs/"$dummy"/mlip/state.mvs ../runs/"$cycle"/mlip/state.mvs
				echo copied file state.mvs from ../runs/$dummy/mlip/ to ../runs/$cycle/mlip/
				echo making a copy of ../runs/$dummy/mlip/trainset.cfg as ../runs/$cycle/mlip/trainsetP.cfg
				cp ../runs/"$dummy"/mlip/trainset.cfg ../runs/"$cycle"/mlip/trainsetP.cfg
				echo copied ../runs/$dummy/mlip/trainset.cfg as ../runs/$cycle/mlip/trainsetP.cfg
				echo copying ../runs/$cycle/mlip/trainsetP.cfg ../runs/$cycle/mlip/trainset.cfg
				cp ../runs/"$cycle"/mlip/trainsetP.cfg ../runs/"$cycle"/mlip/trainset.cfg
				echo copied ../runs/$cycle/mlip/trainsetP.cfg ../runs/$cycle/mlip/trainset.cfg
				echo adding -trainsetN.cfg- to the end of -trainset.cfg- 
				cat ../runs/"$cycle"/mlip/trainsetN.cfg >> ../runs/"$cycle"/mlip/trainset.cfg
				echo added cfgs from trainsetN.cfg to the end of trainset.cfg 
				echo trainset.cfg file is ready for curr.mtp training
			else
				echo skip set as $skip  
				echo detected special case ---- mode is $mode and cycle is $cycle - 
				echo for this special case no pre-existing -state.mvs- and -trainset.cfg- exist in ../../"$dummy"/mlip/
				echo press a key to continue 
				read 
				echo for data backup --- downloading -state.mvs- file from round $dummy to round $cycle mlip subdirectory 
				cp ../runs/"$dummy"/mlip/state.mvs ../runs/"$cycle"/mlip/state.mvs
				echo copied file state.mvs from ../runs/$dummy/mlip/ to ../runs/$cycle/mlip/
				echo adding -trainsetN.cfg- to the end of -trainset.cfg- --- in this case -trainset.cfg- is empty at first 
				cat ../runs/"$cycle"/mlip/trainsetN.cfg >> ../runs/"$cycle"/mlip/trainset.cfg
				echo added cfgs from trainsetN.cfg to the end of trainset.cfg 
				echo trainset.cfg file is ready for curr.mtp training
			fi
			echo ++++++++++++++++++++++++++++++++++++++++
			echo entering training process ...
			echo press a key to continue 
			read 
			./training.sh 
			echo ++++++++++++++++++++++++++++++++++++++++
			echo start monitoring training progress
			echo entering ../runs/$cycle/mlip
			cd ../runs/"$cycle"/mlip
			echo current directory = $(pwd)
				while [ ! -f "curr.mtp_copy" ]
					do
						sleep 30s
				done
			echo file -curr.mtp_copy- detected 
			echo leaving ../runs/$cycle/mlip
			cd ../../../sh/
			echo current directory = $(pwd)
			echo training task completed
			echo cleaning -training.sh- from ../runs/$cycle/mlip
			rm ../runs/"$cycle"/mlip/trainrun.sh 
			echo cleaned -training.sh- from ../runs/$cycle/mlip
			echo ++++++++++++++++++++++++++++++++++++++++
			echo generating MVS file 
			echo press a key to continue 
			read 
			./genMVS.sh
		fi 
		echo ++++++++++++++++++++++++++++++++++++++++
	fi
	cont=0
	echo ++++++++++++++++++++++++++++++++++++++++
	echo initializing lammps MD runs
	echo on server $(hostname)
	echo press a key to continue 
	read 
	echo number of lammps MD runs is m = $m
	echo $m different seeds will be fed to velocity command in lammps input file 
	echo preparing lammps MD run directories
	echo creating directory: ../runs/$cycle/lmpRX/
	mkdir ../runs/"$cycle"/lmpRX/
	echo directory created: ../runs/$cycle/lmpRX/
	echo ++++++++++++++++++++++++++++++++++++++++
    echo preparing to launch lmpRX runs
	echo press a key to continue 
	read 
	./lmpS2.sh
	echo ++++++++++++++++++++++++++++++++++++++++
    echo all lmpRX instances are launched
	echo ++++++++++++++++++++++++++++++++++++++++
	echo checking whether last instace -128- is launched or not to start monitoring 
	while [ ! -d ../runs/$cycle/lmpRX/128/ ]
		do
            sleep 30s
	done 
	echo final instance -128- has been launched  
	echo ++++++++++++++++++++++++++++++++++++++++	
    echo checking lammps run progress and termination ...
    for j in `seq 1 $m`;
    do
        echo checking whether lmpRXrun=$j is completed or not
        echo entering directory ../runs/$cycle/lmpRX/$j/
        cd ../runs/"$cycle"/lmpRX/"$j"/
		echo current directory = $(pwd)
        echo monitoring presence of file -lmpRXfinished-
        while [ ! -f "lmpRXfinished" ]
            do
                sleep 30s
        done
		echo file -lmpRXfinished- detected in directory ../runs/$cycle/lmpRX/$j/
        echo leaving directory ../runs/$cycle/lmpRX/$j/
        cd ../../../../sh/
		echo current directory = $(pwd)
    done
	echo ++++++++++++++++++++++++++++++++++++++++
	echo all lammps instances are checked for termination
	echo ++++++++++++++++++++++++++++++++++++++++
    echo checking failure/success of each lmpRXrun instance
	echo press a key to continue 
	read 
	./checkfail.sh
	echo ++++++++++++++++++++++++++++++++++++++++
    echo deciding whether another training round is needed or not
    echo decision critria = value of sumfails
	echo if value of sumfails is greater than 0 then training is needed
	sumfails=$(cat ../tmp/"SUM")
    echo value of sumfails = $sumfails
    if [ "$sumfails" -gt "0" ]; then
        echo another training is needed
		echo updating training cyle flag -cycleF- 
        cycleF=1
		echo cycle flag is updated -cycleF-=$cycleF
		echo updating cycle counter -cycle- 
		cycle=$(($cycle+1))
		echo cycle counter is updated -cycle-=$cycle 
    else
		echo no further training is needed. 
		echo updating training cyle flag -cycleF-
    	cycleF=0
		echo cycle flag is updated -cycleF-=$cycleF
    fi
	echo exporting cycle value to file -CYCLE- in ../tmp/ directory
	echo "$cycle" > ../tmp/CYCLE
	echo exported cycle value to file -CYCLE- in ../tmp/ directory
	echo press a key to continue 
	read 
	echo ++++++++++++++++++++++++++++++++++++++++
	echo moving all data from home directory to scratch directory - deactivated 
	echo press a key to continue 
	read
	#if [ "$cont" -eq "1" ]; then
	#	cp -avr /$mainpath/runs/$cycle/lmpRX ../../$scratchpath/runs/$cycle/lmpRX
	#	cp -avr /$mainpath/runs/$cycle/mlip/* ../../$scratchpath/runs/$cycle/mlip/
	#else
	#	cp -avr /$mainpath/runs/$cycle ../../$scratchpath/runs/$cycle
	#fi
	#dummy1=$(($cycle-2))
	#rm -r /$mainpath/runs/$dummy1 
done 
fi
# End of file 
