#!/bin/bash

source ~/stackrc
for id in $(ironic node-list | sed -e 1,3d | grep None | awk '{print $2}'); do echo "=> $id"; ironic node-show $id; done
