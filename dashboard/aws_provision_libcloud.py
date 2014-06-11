#!/usr/bin/python
# -*- coding: utf-8 -*-
import os

from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def provision(access_id,
              secret_api_key,
              keypair_name=None,
              node_name="Node",
              sec_groups=['default'],
              image_id='ami-b6bdde86',
              size='t1.micro'):
    # A list of security groups you want this node to be added to
    #sec_groups = ['secgroup1', 'secgroup2']

    cls = get_driver(Provider.EC2_US_WEST_OREGON)
    driver = cls(access_id, secret_api_key)

    sizes = driver.list_sizes()
    images = driver.list_images()
    size = [s for s in sizes if s.id == size][0]

    image = [s for s in images if s.id == image_id][0]

    node = driver.create_node(name=node_name, image=image, size=size,
                              ex_keyname=keypair_name,
                              ex_securitygroup=sec_groups)
    return node