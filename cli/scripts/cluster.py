########################################################
#  Copyright 2020-2021  OpenRDS   All rights reserved. #
########################################################

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
        "  (name, service, created_utc, updated_utc) \n" + \
        "VALUES (?, ?, ?, ?)"
  now = util.sysdate()
  rc = meta.exec_sql(sql, [name, service, now, now])
  return(rc)


def read(name=None):
  where = "1 = 1"
  if name:
    where = "name = '" + str(name) + "'"
  
  sql = "SELECT name, service, created_utc, updated_utc \n" + \
        "  FROM clusters WHERE " + where + " ORDER BY 2, 1"

  data = meta.exec_sql_list(sql)
  return data


def update(name):
  sql = "UPDATE clusters SET updated_utc = ? WHERE name = ?"
  meta.exec_sql(sql, [util.sysdate(), name])
  return


def delete (name):
  sql = "DELETE FROM clusters WHERE name = ?"
  meta.exec_sql(sql, [name])
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
