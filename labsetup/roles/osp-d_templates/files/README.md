This directory contains Heat templates to help configure
VLANs in an environment with multiple  NICs for each Overcloud role.

The templates also specify the external/public API access on a
dedicated flat network, using the standard br-ex bridge name.

Configuration
-------------

To make use of these templates create a Heat environment that looks
something like this:

  resource\_registry:
    OS::TripleO::BlockStorage::Net::SoftwareConfig: network/config/multiple-nic-vlans/cinder-storage.yaml
    OS::TripleO::Compute::Net::SoftwareConfig: network/config/multiple-nic-vlans/compute.yaml
    OS::TripleO::Controller::Net::SoftwareConfig: network/config/multiple-nic-vlans/controller.yaml
    OS::TripleO::ObjectStorage::Net::SoftwareConfig: network/config/multiple-nic-vlans/swift-storage.yaml
    OS::TripleO::CephStorage::Net::SoftwareConfig: network/config/multiple-nic-vlans/ceph-storage.yaml

Or use this Heat environment file:

  environments/net-multiple-nic-with-vlans.yaml
