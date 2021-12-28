#!/bin/bash --login
oworkdir=$( pwd )
for folder in $( find . -type d | grep pmf )
do
	foldername=${folder:2}
	cd $foldername
	cp ../sync_states.sh ./run-sets.sh
	pwd
	cd ..
done
