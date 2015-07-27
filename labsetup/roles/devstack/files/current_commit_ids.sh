#!/bin/bash

export LANG=C

date

find $(pwd) /opt/stack/ -name .git | while read dotgit; do
	topdir=${dotgit%/.git}
	echo "==> ${topdir}"
	(cd ${topdir} && git branch)
	cat ${topdir}/.git/refs/heads/master
	grep url ${topdir}/.git/config
done
