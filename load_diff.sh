#!/bin/bash
cd
export WORKDIR_OSM=$HOME/.osmosis
while true 
do 
	START=$(date +%s)
	if ! [ -d $WORKDIR_OSM/expires/ ]
	then
		mkdir $WORKDIR_OSM/expires
	fi
	if [ $(find $WORKDIR_OSM/changes/ -name '*.osc' -print | wc -l) -gt 1 ]
	then 
		OSC_FILE=$(find $WORKDIR_OSM/changes/ -name '*.osc' | head -n 1)
		# --bbox minlon,minlat,maxlon,maxlat
		# France : -6,41,10,52
		# Nord : 1,50,5,51.5
		time osm2pgsql --append -S beciklo.style -G -s -v -m --bbox 1,50,5,51.5 -d gis -C 3072 $OSC_FILE -e15 -o /tmp/$START.list
	fi
	if [ $? -eq 0 ]
	then
		rm $OSC_FILE
		mv /tmp/$START.list $WORKDIR_OSM/expires/
	else
		rm /tmp/$START.list
	fi

	DELAY=$(( $(date +%s) - $START ))
	echo $DELAY> /tmp/delay_osm2pgsql
	if [ $DELAY -gt 60 ]
	then
		sleep 1
	else 
		sleep 10
	fi
done
