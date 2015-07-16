#!/bin/bash -x

if [ x"$#" != x"4" ]; then
	echo "$0 name cpu memMB storageGB"
	exit 1
fi
#NAME=rhel7-minimum
NAME=$1; shift

HNAM=$(echo $NAME|tr -s [:upper:] [:lower:]|sed -e 's/\./\-/g')
VARIANT=rhel7 # could refer this value on virt-install(1)
#ISO=/home/ori/rhel-server-7.0-x86_64-dvd.iso
ISO=/srv/binaries/isos/RHEL/7/1/x86_64/default/rhel-server-7.1-x86_64-dvd.iso
REPOSERVER=10.64.193.148


#CPU=2
#MEM=2048 #MB
#HDD=16   #GB
CPU=$1; shift
MEM=$1; shift
HDD=$1; shift

cat > ${NAME}-ks.cfg << EOF
#cdrom
firstboot --disable
ignoredisk --only-use=vda
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
#network  --bootproto=dhcp --device=eth0 --ipv6=auto
network --device=eth0 --ipv6=auto --bootproto=dhcp
network --onboot=yes --device=eth1 --ipv6=auto --bootproto=static --ip=10.0.1.8 --netmask=255.255.255.0 --gateway=10.0.1.8
network --onboot=yes --device=eth2 --ipv6=auto --bootproto=static --ip=10.0.9.8 --netmask=255.255.255.0 --gateway=10.0.9.254 --nameserver=10.64.255.25
network --onboot=yes --device=eth3 --ipv6=auto --bootproto=static --ip=10.0.0.8 --netmask=255.255.255.0 --gateway=10.0.0.8
network --onboot=yes --device=eth4 --ipv6=auto --bootproto=static --ip=10.0.2.8 --netmask=255.255.255.0 --gateway=10.0.2.8
network  --hostname=${NAME}.osp6test.local
# Root password
rootpw redhat
user --name=ori --groups=wheel --password=orimanabu --plaintext
# System timezone
timezone Asia/Tokyo
# System bootloader configuration
bootloader --location=mbr --boot-drive=vda
autopart --type=lvm
# Partition clearing information
clearpart --all --initlabel --drives=vda

%packages
@core
#git
#subversion
#zsh
#sudo
#vim-enhanced
#lftp
#curl
#wireshark
#rsync
#traceroute
#wget
#tcpdump
#ntp
#man
#bind-utils
#nfs-utils
#autofs
#xterm
#sysstat
#patch
#strace
#httpd
#vsftpd
#socat
#nmap-ncat
#strace
#psmisc
#
#
%end

%pre
## copied from cobbler licensed under GPLv2+
#set -x -v
#exec 1>/tmp/ks-pre.log 2>&1
#
#while : ; do
#    sleep 10
#    if [ -d /mnt/sysimage/root ]; then
#        cp /tmp/ks-pre.log /mnt/sysimage/root/
#        logger "Copied %pre section log to system"
#        break
#    fi
#done &
%end


%post --nochroot

%end

%post
set -x -v
exec 1>/root/ks-post.log 2>&1
test -f /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release || :

#sed -i.save 's/^\(%wheel.*\)ALL$/\1NOPASSWD: ALL/' /etc/sudoers
#
##systemctl disable NetworkManager.service
##chkconfig network on
#
#cat << REPOEOF > /etc/yum.repos.d/binaries.repo
#[binaries-rhel-7-0]
#name=binaries: RHEL 7.0
#baseurl=http://binaries.nrt.redhat.com/contents/RHEL/7/0/x86_64/default
#enabled=1
#gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
#REPOEOF
#
#cat << REPOEOF > /etc/yum.repos.d/localrepo-rhel7.repo
#[local-rhel-7-server-rpms]
#name=local-rhel-7-server-rpms
#baseurl=http://${REPOSERVER}/repos/rhel-7-server-rpms
#enabled=1
#gpgcheck=0
#
#[local-rhel-7-server-optional-rpms]
#name=local-rhel-7-server-optional-rpms
#baseurl=http://${REPOSERVER}/repos/rhel-7-server-optional-rpms
#enabled=1
#gpgcheck=0
#
#[local-rhel-7-server-rh-common-rpms]
#name=local-rhel-7-server-rh-common-rpms
#baseurl=http://${REPOSERVER}/repos/rhel-7-server-rh-common-rpms
#enabled=1
#gpgcheck=0
#
#[local-rhel-7-server-openstack-5.0-rpms]
#name=local-rhel-7-server-openstack-5.0-rpms
#baseurl=http://${REPOSERVER}/repos/rhel-7-server-openstack-5.0-rpms
#enabled=0
#gpgcheck=0
#
#[local-rhel-7-server-openstack-6.0-rpms]
#name=local-rhel-7-server-openstack-6.0-rpms
#baseurl=http://${REPOSERVER}/repos/rhel-7-server-openstack-6.0-rpms
#enabled=1
#gpgcheck=0
#
#[local-rhel-7-server-openstack-6.0-installer-rpms]
#name=local-rhel-7-server-openstack-6.0-installer-rpms
#baseurl=http://${REPOSERVER}/repos/rhel-7-server-openstack-6.0-installer-rpms
#enabled=1
#gpgcheck=0
#REPOEOF
#
%end

reboot



EOF


#sudo setenforce 0
#sudo mkdir -pv /var/lib/libvirt/images/${NAME}_iso
#sudo umount -v /var/lib/libvirt/images/${NAME}_iso
#sudo mount -vo loop ${ISO} /var/lib/libvirt/images/${NAME}_iso

virsh dominfo ${NAME} && \
{ virsh destroy ${NAME}; virsh detach-disk ${NAME} --target vda --persistent && virsh undefine ${NAME}; }


#virt-install \
#    --connect=qemu:///system \
#    --accelerate \
#    --hvm \
#    --vcpus=${CPU} \
#    --cpu=host \
#    --name=${NAME} \
#    --os-type=linux \
#    --os-variant=${VARIANT} \
#    --ram=${MEM} \
#    --disk path=/var/lib/libvirt/images/${NAME}.img,size=${HDD} \
#    --disk path=${ISO},device=cdrom \
#    --force \
#    --network=bridge:br0,model=virtio \
#    --network=bridge:virbr100,model=virtio \
#    --network=bridge:virbr5,model=virtio \
#    --location=/var/lib/libvirt/images/${NAME}_iso \
#    --nographics \
#    --console pty,target_type=serial \
#    --extra-args="text console=tty0 console=ttyS0,115200 serial rd_NO_PLYMOUTH ks=file:/${NAME}-ks.cfg net.ifnames=0" \
#    --initrd-inject=$(pwd)/${NAME}-ks.cfg

virt-install \
    --connect=qemu:///system \
    --accelerate \
    --noreboot \
    --hvm \
    --vcpus=${CPU} \
    --cpu=host \
    --name=${NAME} \
    --os-type=linux \
    --os-variant=${VARIANT} \
    --ram=${MEM} \
    --disk path=/var/lib/libvirt/images/${NAME}.qcow2,format=qcow2,size=${HDD},sparse=true \
    --force \
    --network=bridge:br1,model=virtio \
    --network network=mgmt,model=virtio \
    --network network=foreman,model=virtio \
    --network network=storage,model=virtio \
    --network network=tenant,model=virtio \
    --network network=external,model=virtio \
    --location=http://binaries.nrt.redhat.com/contents/RHEL/7/1/x86_64/default/ \
    --nographics \
    --console pty,target_type=serial \
    --extra-args="text console=tty0 console=ttyS0,115200 serial rd_NO_PLYMOUTH ks=file:/${NAME}-ks.cfg" \
    --initrd-inject=$(pwd)/${NAME}-ks.cfg

resize
