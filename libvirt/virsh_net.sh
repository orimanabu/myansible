#!/bin/bash

echo "=> undefine"
networks="mgmt storage tenant external foreman"
zone=trusted
zone=FedoraServer

for net in ${networks}; do
	echo "==> ${net}"
	virsh net-destroy ${net}
	virsh net-undefine ${net}
done

echo "=> define"
for net in ${networks}; do
	echo "==> ${net}"
	virsh net-define ${net}.xml
	virsh net-start ${net}
	virsh net-autostart ${net}
done

echo "=> firewall-cmd"
for net in ${networks}; do
	echo "==> ${net}"
	bridge=$(virsh net-dumpxml ${net} | awk '/bridge name=/ {print $2}' | sed -e "s/name='\(.*\)'/\1/")
	echo "bridge: ${bridge}"
	firewall-cmd --change-interface=${bridge} --zone=${zone}
	firewall-cmd --change-interface=${bridge} --zone=${zone} --permanent
done
firewall-cmd --get-active-zones
