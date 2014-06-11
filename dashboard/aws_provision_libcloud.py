#!/usr/bin/python
# -*- coding: utf-8 -*-
import os

from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def provision(access_id,
              secret_api_key,
              node_name="Node",
              keypair_name=None,
              sec_groups=['default'],
              image_id='ami-b6bdde86',
              size='t1.micro',
              timeout=60, **kw):
    # A list of security groups you want this node to be added to
    #sec_groups = ['secgroup1', 'secgroup2']
    print "Starting provisioning..."
    cls = get_driver(Provider.EC2_US_WEST_OREGON)
    driver = cls(access_id, secret_api_key)

    sizes = driver.list_sizes()
    images = driver.list_images()
    size = [s for s in sizes if s.id == size][0]

    image = [s for s in images if s.id == image_id][0]
    kwargs = {}
    kwargs.update(kw)
    if keypair_name:
        kwargs['ex_keyname'] = keypair_name
    node = driver.create_node(name=node_name, image=image, size=size,
                              ex_securitygroup=sec_groups, **kwargs)
    try:
        driver.wait_until_running([node], wait_period=5, timeout=timeout)
        print "Provisioning finished"
    except Exception, ex:
        print "Provisioning failed, %r" % ex

    return node
