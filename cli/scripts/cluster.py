###############################################################
#  Copyright 2020-2021  PGSQL.  AGPLV3.  All rights reserved. #
###############################################################

import util, meta, api, cloud

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver
                                                                                   
                                                                                   
def list_images(cloud_name):
  try:
    driver = cloud.get_cloud_driver(cloud_name)
    images = driver.list_images()
  except Exception as e:
    util.message(str(e), "error")

  headers = ['Name', 'ID']
  keys    = ['name', 'id']
    
  jsonList = []
    
  for image in images:
    dict = {}
    dict['id'] = str(image.id)
    dict['name'] = str(image.name)
    jsonList.append(dict)

  if os.getenv("isJson", None):
    print(json.dumps(jsonList, sort_keys=True, indent=2))
  else:
    print(api.format_data_to_table(jsonList, keys, headers))

  return


def list_sizes(cloud_name):
  try:
    driver = cloud.get_cloud_driver(cloud_name)
    sizes = driver.list_sizes()
  except Exception as e:
    util.message(str(e), "error")
    return

  headers = ['Name', 'ID', 'vCPUs', 'RAM', 'Disk', 'Price']
  keys    = ['name', 'id', 'vcpus', 'ram', 'disk', 'price']
   
  jsonList = []
   
  for size in sizes:
    dict = {}

    dict['id'] = str(size.id)
    dict['name'] = str(size.name)
    try:
      dict['vcpus'] = str(size.vcpus)
    except:
      dict['vcpus'] = ""
    dict['ram'] = str(size.ram)
    dict['disk'] = str(size.disk)

    price = str(size.price)
    if price == "0.0":
      dict['price'] = ""
    else:
      dict['price'] = price

    jsonList.append(dict)

  if os.getenv("isJson", None):
    print(json.dumps(jsonList, sort_keys=True, indent=2))
  else:
    print(api.format_data_to_table(jsonList, keys, headers))

  return


def list_locations(cloud_name):
  try:
    driver = cloud.get_cloud_driver(cloud_name)
    locations = driver.list_locations()
  except Exception as e:
    util.message(str(e), "error")

  headers = ['Name', 'Country']
  keys    = ['name', 'country']

  jsonList = []

  for loct in locations:
    dict = {}
    dict['name'] = str(loct.name)
    dict['country'] = str(loct.country)
    jsonList.append(dict)

  if os.getenv("isJson", None):
    print(json.dumps(jsonList, sort_keys=True, indent=2))
  else:
    print(api.format_data_to_table(jsonList, keys, headers))

  
  return


def create(name, service):
  sql = "INSERT INTO clusters \n" + \
        "  (id, name, service, created_utc, updated_utc) \n" + \
        "VALUES (?, ?, ?, ?, ?)"
  now = util.sysdate()
  cluster_id = util.get_uuid()
  rc = meta.exec_sql(sql, [cluster_id, name, service, now, now])
  util.message(cluster_id, "info")

  return


def read(cluster_id=None):
  where = "1 = 1"
  if cluster_id:
    where = "id = '" + str(cluster_id) + "'"
  
  sql = "SELECT id, name, service, created_utc, updated_utc \n" + \
        "  FROM clusters WHERE " + where

  data = meta.exec_sql_list(sql)
  return data


def update(cluster_id, name, service):
  sql = "UPDATE clusters \n" + \
        "   SET name = ?, service = ?, updated_utc = ? " + \
        " WHERE id = ?"
  now = util.sysdate()
  meta.exec_sql(sql, [name, service, now, cluster_id])
  return


def delete (cluster_id):
  sql = "DELETE FROM clusters WHERE id = ?"
  meta.exec_sql(sql, [cluster_id])
  return


## MAINLINE ##########################################

clusterAPIs = {
  'create': create,
  'read': read,
  'update': update,
  'delete': delete,
  'list-images': list_images,
  'list-sizes': list_sizes,
  'list-locations': list_locations
}

if __name__ == '__main__':
  fire.Fire(clusterAPIs)
