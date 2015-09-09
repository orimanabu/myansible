#!/bin/bash

source ~/stackrc

echo "=> heat stack-list --show-nested"
date
heat stack-list --show-nested
date

echo "=> heat resource-list overcloud"
date
heat resource-list overcloud
date

echo "=> heat resource-list -n5 overcloud"
date
heat resource-list -n5 overcloud
date
