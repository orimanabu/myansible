#!/bin/bash

task=common
if [ x"$1" != x"" ]; then
	task=$1; shift
fi
echo "task: ${task}"
mkdir -p roles/${task}/{files,templates,tasks,handlers,vars,meta}
