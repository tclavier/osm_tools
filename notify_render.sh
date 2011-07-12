#!/bin/bash
cd
export WORKDIR_OSM=$HOME/.osmosis
while true 
do 
	START=$(date +%s)
	for EXPIR_FILE in $(find $WORKDIR_OSM/expires -name '*.list' -print)
	do
		cat $EXPIR_FILE | render_expired --map=tango --min-zoom=10 --touch-from=10 --num-threads=2
		cat $EXPIR_FILE | render_expired --map=beciklo --min-zoom=10 --touch-from=10 --num-threads=2
		cat $EXPIR_FILE | render_expired --map=beciklo_pistes --min-zoom=10 --touch-from=10 --num-threads=2
		cat $EXPIR_FILE | render_expired --map=beciklo_infos --min-zoom=10 --touch-from=10 --num-threads=2
		rm $EXPIR_FILE
	done

	DELAY=$(( $(date +%s) - $START ))
	echo "$DELAY" > /tmp/delay_notifyRender
	sleep 300
done
