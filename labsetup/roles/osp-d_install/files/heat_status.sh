#!/bin/bash

source ~/stackrc
while true; do heat stack-list --show-nested; sleep 1; done
