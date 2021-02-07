########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import util, meta, api, cloud, node

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def list():
  headers = ['Group', 'Type', 'Type Name', 'Service', 'Port', 'Image', 'Project URL', 'Description']
  keys    = ['svc_group', 'svc_type', 'svc_type_name', 'service', 'port', 'image_file', 'project_url', 'description']

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


def group_list(cloud_name, group_id=None, group_name=None):
  return


def group_create(cloud_name, group_name, port, cidr="0.0.0.0/0"):
  group_id = None

  return(group_id)


def group_delete(cloud_name, group_name=None, group_id=None):
  if ((group_id == None and group_name == None) or
      (group_id and group_name)):
    util.message("Must specify group_id or group_name", "error")
    return

  return


secAPIs = {
  'group-list': group_list,
  'group-create': group_create,
  'group-delete': group_delete
}

if __name__ == '__main__':
  fire.Fire(secAPIs)
