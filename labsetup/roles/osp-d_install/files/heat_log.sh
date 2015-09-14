#!/bin/bash

x=0
while true; do
	y=$(printf "%03d" ${x})
	./heat_sub.sh > log.heatlog.${y} 2>&1
	sleep 3
	(( x = x + 1 ))
done
