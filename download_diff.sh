#!/bin/bash
cd
export WORKDIR_OSM=$HOME/.osmosis
while true 
do 
	START=$(date +%s)
	if ! [ -d $WORKDIR_OSM/changes ]
	then
		mkdir $WORKDIR_OSM/changes
	fi
	
	if [ $(find $WORKDIR_OSM/changes -name '*.osc' | wc -l) -lt 9 ]
	then
		osmosis --read-replication-interval workingDirectory=$WORKDIR_OSM --simplify-change --write-xml-change $WORKDIR_OSM/changes/$START.osc
	fi

	DELAY=$(( $(date +%s) - $START ))
	echo "$DELAY" > /tmp/download_diff
	# On ne télécharge les diffs que toutes les 5min
	sleep 300
done
