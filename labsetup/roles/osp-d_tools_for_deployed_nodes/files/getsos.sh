#!/bin/bash

destdir=/home/heat-admin
owner=heat-admin
group=${owner}
file=sosreport*.tar.xz

#sosreport --batch
mv /var/tmp/${file} ${destdir}
chown ${owner}:${group} ${destdir}/${file}
