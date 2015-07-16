#!/bin/bash

if [ x"$#" != x"2" ]; then
	echo "$0 vm network"
	exit 1
fi
vm=$1; shift
network=$1; shift

node=$(virsh dumpxml ${vm} | xpath '//interface[@type="network"]/source[@network="'${network}'"]/../mac' 2>&1 | sed -e '1,2d')
#echo ${node}
mac=$(echo ${node} | sed -e 's/^ *<mac address="//' -e 's/" *\/>$//')
#echo ${mac}
addr=$(grep ${mac} /var/lib/libvirt/dnsmasq/${network}.leases | awk '{print $3}')
echo ${addr}
