#!/bin/bash

export LANG=C
source ~/stackrc
while true; do heat stack-list --show-nested; date; sleep 1; done
