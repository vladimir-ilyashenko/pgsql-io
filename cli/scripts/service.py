########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import util, meta, api, cloud

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def list():
  headers = ['Group', 'Type', 'Type Name', 'Service', 'Image', 'Project URL', 'Description']
  keys    = ['svc_group', 'svc_type', 'svc_type_name', 'service', 'image_file', 'project_url', 'description']

  sql = "SELECT svc_group, svc_type, svc_type_name, service, \n" + \
        "       image_file, project_url, description \n" + \
        "  FROM v_services"

  data = meta.exec_sql_list(sql)

  l_svc = []
  for d in data:
    dict = {}
    dict['svc_group'] = str(d[0])
    dict['svc_type'] = str(d[1])
    dict['svc_type_name'] = str(d[2])
    dict['service'] = str(d[3])
    dict['image_file'] = str(d[4])
    dict['project_url'] = str(d[5])
    dict['description'] = str(d[6])
    l_svc.append(dict)

  util.print_list(headers, keys, l_svc)

  return


svcAPIs = {
  'list': list
}

if __name__ == '__main__':
  fire.Fire(svcAPIs)
