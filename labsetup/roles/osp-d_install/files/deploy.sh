#!/bin/bash

./heat_log.sh &
pid=$!
sleep 5
time openstack overcloud deploy --templates --ntp-server 10.5.26.10 --control-scale 1 --compute-scale 1 --neutron-tunnel-types vxlan --neutron-network-type vxlan --libvirt-type kvm --neutron-public-interface eth1
kill -9 ${pid}
