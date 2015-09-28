#!/bin/bash

if [ x"$#" != x"1" ]; then
	echo "$0 destdir"
	exit 1
fi
destdir=$1; shift
private_key=~/id_rsa_openstack
user=heat-admin

mkdir -p ${destdir}

for i in $(seq 102 107); do
	host=10.0.9.${i}
	echo "=> ${host}"
	ping -c1 -W1 ${host} > /dev/null 2>&1
	if [ x"$?" != x"0" ]; then
		echo "${host} is not alive, skipping..."
		continue
	fi
	scp -i ${private_key} ${user}@${host}:'sosreport*.tar.xz' ${destdir}
done
