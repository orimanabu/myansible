#!/bin/bash

time openstack undercloud install 2>&1 | tee log.undercloud_install

source stackrc 

openstack overcloud image upload
openstack image list

subnet_id=$(neutron subnet-list | awk '/start.*end/ {print $2}')
neutron subnet-update ${subnet_id} --dns-nameserver 10.0.1.254
neutron subnet-show ${subnet_id}

plan_id=$(openstack management plan list | awk '/overcloud/ {print $2}')
openstack management plan show ${plan_id}
openstack management plan download ${plan_id} -O ~/templates/overcloud-plan/

#openstack baremetal introspection bulk start
#openstack flavor set --property "capabilities:boot_option"="local" baremetal


source startrc
openstack baremetal import --json ~/instackenv.json
openstack baremetal configure boot
openstack baremetal introspection bulk start
ironic node-update 61493dd7-4503-4120-81b3-790cffa5f89c add properties/capabilities='profile:controller,boot_option:local'
ironic node-update 414c3282-4ec7-4580-9b09-8eb387cfa025 add properties/capabilities='profile:compute,boot_option:local'
openstack flavor create --id auto --ram 6144 --disk 40 --vcpus 2 controller
openstack flavor create --id auto --ram 6144 --disk 40 --vcpus 2 compute
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="controller" controller
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="compute" compute

cp -r /usr/share/openstack-tripleo-heat-templates/network/config/single-nic-vlans ~/templates/nic-configs
vim templates/nic-configs/controller.yaml
vim ~/templates/network-environment.yaml
