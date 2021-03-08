########################################################
#  Copyright 2020-2021  OpenRDS   All rights reserved. #
########################################################

import util, meta, api, cloud

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver
                                                                                   
                                                                                   
def create(name, service):
  sql = "INSERT INTO clusters \n" + \
        "  (name, service, created_utc, updated_utc) \n" + \
        "VALUES (%s, %s, %s, %s)"
  now = util.sysdate()
  rc = cloud.exec_sql(sql, [name, service, now, now])
  return(rc)


def list(name=None):
  where = "1 = 1"
  if name:
    where = "name = '" + str(name) + "'"
  
  sql = "SELECT name, service, created_utc, updated_utc \n" + \
        "  FROM clusters WHERE " + where + " ORDER BY 2, 1"

  data = cloud.exec_sql_list(sql)
  return data


def update(name):
  sql = "UPDATE clusters SET updated_utc = %s WHERE name = %s"
  cloud.exec_sql(sql, [util.sysdate(), name])
  return


def delete (name):
  sql = "DELETE FROM clusters WHERE name = %s"
  cloud.exec_sql(sql, [name])
  return


## MAINLINE ##########################################

clusterAPIs = {
  'create': create,
  'list': list,
  'update': update,
  'delete': delete,
}

if __name__ == '__main__':
  fire.Fire(clusterAPIs)
