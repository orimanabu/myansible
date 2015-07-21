#!/usr/bin/python

from subprocess import Popen,PIPE
from lxml import etree
import re
import sys
import json

data = {}

def mac_ipaddr(xml):
    mac_ipaddr = {x.xpath('./source')[0].get('network'): {'mac': x.xpath('./mac[@address]')[0].get('address')}
                for x in xml.xpath('//interface[@type="network"]')}
    return mac_ipaddr

def get_vm_xml(vm):
    pipe = Popen(['virsh', 'dumpxml', vm], stdout=PIPE, universal_newlines=True)
    xml = etree.fromstring(pipe.stdout.read())
    return xml

def get_vm_list():
    pipe = Popen(['virsh', '-q', '-c', 'qemu:///system', 'list', '--name', '--all'], stdout=PIPE, universal_newlines=True)
    vms = [x[:-1] for x in pipe.stdout.readlines()]
    return vms

def main():
    for vm in get_vm_list():
        xml = get_vm_xml(vm)
        ma = mac_ipaddr(xml)
        data[vm] = ma
    #print json.dumps(data)
    network = 'foreman'
    for vm in sorted(data.keys()):
        if data[vm].get(network):
            mac = data[vm][network]['mac']
            hostname = re.sub(r'^[^-]+-', '', vm)
            print "%s,%s,%s" % (vm, mac, hostname)
        else:
            print "!!! %s is not connected to %s" % (vm, network)

if __name__ == '__main__':
    main()
