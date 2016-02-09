#!/bin/bash

if [ x"$#" != x"4" ]; then
	echo "$0 ORIG NODE_NAME CPU MEMORY"
	exit 1
fi

orig=$1; shift
node=$1; shift
cpu=$1; shift
memoryMB=$1; shift

imgpath=/var/lib/libvirt/images
suffix=.qcow2

function clone_image {
	local orig=$1; shift
	local node=$1; shift
	qemu-img create -f qcow2 -b ${imgpath}/${orig}${suffix} ${imgpath}/${node}${suffix}
}

function create_xml {
	local node=$1; shift
	local cpu=$1; shift
	local memoryMB=$1; shift
	virt-install \
	    --name ${node} \
	    --vcpus ${cpu} \
	    --ram ${memoryMB} \
	    --os-variant rhel7 \
	    --disk path=${imgpath}/${node}${suffix},device=disk,bus=virtio,format=qcow2 \
	    --noautoconsole \
	    --vnc \
	    --network=bridge:br0,model=virtio \
	    --network network=mgmt,model=virtio \
	    --network network=tenant,model=virtio \
	    --network network=external,model=virtio \
	    --dry-run \
	    --print-xml \
	> /tmp/${node}.xml
}

function define_vm {
	local node=$1; shift
	virsh define --file /tmp/${node}.xml
}

clone_image ${orig} ${node}
create_xml ${node} ${cpu} ${memoryMB}
define_vm ${node}
