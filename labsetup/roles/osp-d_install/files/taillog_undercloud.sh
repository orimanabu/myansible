#!/bin/bash

sudo journalctl -fla | grep -Ev '(proxy|container|account|object)-server|DEBUG'
