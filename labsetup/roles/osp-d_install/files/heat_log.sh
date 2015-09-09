#!/bin/bash

x=0
while true; do
	y=$(printf "%03d" ${x})
	./heat_sub.sh 2>&1 | tee log.heatlog.${y}
	sleep 60
	(( x = x + 1 ))
done
