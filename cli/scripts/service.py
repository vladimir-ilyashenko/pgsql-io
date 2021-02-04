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
  headers = ['Group', 'Type', 'Type Name', 'Service']
  keys    = ['svc_group', 'svc_type', 'svc_type_name', 'service']

  sql = "SELECT svc_group, svc_type, svc_type_name, service \n" + \
        "  FROM v_services"

  data = meta.exec_sql_list(sql)

  l_svc = []
  for d in data:
    dict = {}
    dict['svc_group'] = str(d[0])
    dict['svc_type'] = str(d[1])
    dict['svc_type_name'] = str(d[2])
    dict['service'] = str(d[3])
    l_svc.append(dict)

  util.print_list(headers, keys, l_svc)

  return


svcAPIs = {
  'list': list
}

if __name__ == '__main__':
  fire.Fire(svcAPIs)
