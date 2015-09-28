#!/bin/bash

ssh-keygen -R 172.16.99.101
for i in $(seq 102 107); do ssh-keygen -R 10.0.9.$i; done
