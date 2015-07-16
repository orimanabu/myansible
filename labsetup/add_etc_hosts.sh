#!/bin/bash

if [ x"$#" != x"3" ]; then
	echo "$0 target addr line"
	exit 1
fi

target=$1; shift
addr=$1; shift
line=$1; shift

ssh ${target} grep ${addr} /etc/hosts || grep ${addr} /etc/hosts | grep -v '^#' | ssh ${target} 'cat | sudo tee -a /etc/hosts'
