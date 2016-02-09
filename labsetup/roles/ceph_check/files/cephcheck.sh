#!/bin/bash

echo "=> ceph quorum_status --format json-pretty"
ceph quorum_status --format json-pretty
echo "==> $?"

echo "=> ceph health"
ceph health
echo "==> $?"

echo "=> ceph -s"
ceph -s
echo "==> $?"

echo "=> ceph osd tree"
ceph osd tree
echo "==> $?"

echo "=> ceph auth list"
ceph auth list
echo "==> $?"

echo "=> ceph config-key list"
ceph config-key list
echo "==> $?"

echo "=> ceph df"
ceph df
echo "==> $?"

echo "=> ceph fsid"
ceph fsid
echo "==> $?"

echo "=> ceph heap stats"
ceph heap stats
echo "==> $?"

echo "=> ceph mds dump"
ceph mds dump
echo "==> $?"

echo "=> ceph mon dump"
ceph mon dump
echo "==> $?"

echo "=> ceph mon stat"
ceph mon stat
echo "==> $?"

echo "=> ceph mon_status | python -m json.tool"
ceph mon_status | python -m json.tool
echo "==> $?"

echo "=> ceph osd crush rule list"
ceph osd crush rule list
echo "==> $?"

echo "=> ceph osd crush show-tunables"
ceph osd crush show-tunables
echo "==> $?"

echo "=> ceph osd dump"
ceph osd dump
echo "==> $?"

echo "=> ceph osd pool stats"
ceph osd pool stats
echo "==> $?"

echo "=> ceph osd lspools"
ceph osd lspools
echo "==> $?"

echo "=> ceph osd stat"
ceph osd stat
echo "==> $?"

echo "=> ceph pg dump summary"
ceph pg dump summary
echo "==> $?"

echo "=> ceph pg dump_json | python -m json.tool"
ceph pg dump_json | python -m json.tool
echo "==> $?"

echo "=> ceph pg stat"
ceph pg stat
echo "==> $?"

echo "=> ceph status"
ceph status
echo "==> $?"

