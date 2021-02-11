########################################################
#  Copyright 2020-2021  OpenRDS   All rights reserved. #
########################################################

import util, meta, api, cloud, node

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def install(cloud_name, node_id, service, component=None):
  ##if not node.is_valid("running"):
  ##  return

  if service in ("postgres", "pg", "postgresql"):
    service = "pg"
    if component == None:
      component = "pg13"
    cmd = "install " + str(component) + " --autostart"
    return(node.io_cmd(cloud_name, node_id, cmd))

  elif service in ("mariadb", "mysql"):
    service = "mariadb"
    return(node.io_cmd(cloud_name, node_id, "install mariadb"))

  else:
    util.message("service not supported", "error")

  return


def list():
  headers = ['Group', 'Type', 'Type Name', 'Service', 'Port', 'Description']
  keys    = ['svc_group', 'svc_type', 'svc_type_name', 'service', 'port', 'description']

  sql = "SELECT svc_group, svc_type, svc_type_name, service, \n" + \
        "       port, image_file, project_url, description \n" + \
        "  FROM v_services"

  data = meta.exec_sql_list(sql)

  l_svc = []
  for d in data:
    dict = {}
    dict['svc_group'] = str(d[0])
    dict['svc_type'] = str(d[1])
    dict['svc_type_name'] = str(d[2])
    dict['service'] = str(d[3])
    dict['port'] = str(d[4])
    dict['image_file'] = str(d[5])
    dict['project_url'] = str(d[6])
    dict['description'] = str(d[7])
    l_svc.append(dict)

  util.print_list(headers, keys, l_svc)

  return


svcAPIs = {
  'list': list,
  'install': install
}

if __name__ == '__main__':
  fire.Fire(svcAPIs)
