########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import util, meta, api, cloud

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def import_from_file(cloud_name, name, pub_key_file):
  try:
    driver = cloud.get_cloud_driver(cloud_name)                                          
    driver.import_key_pair_from_file(name, pub_key_file)                                                    
  except Exception as e:                                                           
    util.fatal_error(str(e))


def destroy(cloud_name, name):
  try:
    driver = cloud.get_cloud_driver(cloud_name)                                          
    key = driver.get_key_pair(name)
    driver.delete_key_pair(key)                                                    
  except Exception as e:                                                           
    util.fatal_error(str(e))


def list(cloud_name):                                                  
  try:
    driver = cloud.get_cloud_driver(cloud_name)                                          
    kk = driver.list_key_pairs()                                                    
  except Exception as e:                                                           
    util.fatal_error(str(e))

  headers = ['Name']                                               
  keys    = ['name']                                              
                                                                                   
  jsonList = []                                                                    
                                                                                   
  for key in kk:
    dict = {}
    dict['name'] = key.name

    jsonList.append(dict)
                                                                                   
  if os.getenv("isJson", None):                                                    
    print(json.dumps(jsonList, sort_keys=True, indent=2))                          
  else:                                                                            
    print(api.format_data_to_table(jsonList, keys, headers))                       
                                                                                   
  return


def insert(name, username, pem_file):
  now = util.sysdate()

  if not os.path.isfile(pem_file):
    util.message("WARNING: pem_file not found", "info")

  sql = "INSERT INTO keys (name, username, pem_file, \n" + \
        "  created_utc, updated_utc) VALUES (?,?,?,?,?)"

  rc = meta.exec_sql(sql, [name, username, pem_file, now, now])

  return(rc)


def read(key_name):

  sql = "SELECT username, pem_file, \n" + \
        "       created_utc, updated_utc \n" + \
        "  FROM keys WHERE name = ?"

  data = meta.exec_sql(sql, [key_name])
  return(str(data[0]), str(data[1]))


def update(name, username, pem_file):
  if not os.path.isfile(pem_file):
    util.message("WARNING: pem_file not found", "info")

  sql = "UPDATE keys SET username = ?, pem_file = ?, updated_utc = ? \n" + \
        " WHERE name = ?"

  rc =  meta.exec_sql(sql, [username, pem_file, util.sysdate(), name])
  return(rc)


def delete(name):
  sql = "DELETE FROM keys WHERE name = ?"

  rc = meta.exec_sql(sql, [name])
  return(rc)


keyAPIs = {
  'list': list,
  'import-from-file': import_from_file,
  'destroy': destroy,
  'insert': insert,
  'read': read,
  'update': update,
  'delete': delete
}

if __name__ == '__main__':
  fire.Fire(keyAPIs)
