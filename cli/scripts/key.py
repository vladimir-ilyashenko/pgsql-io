########################################################
#  Copyright 2020-2021  OpenRDS   All rights reserved. #
########################################################

import util, cloud

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


def list_cloud_keys(cloud_name):                                                  
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
          
  util.print_list(headers, keys, jsonList)
                                                                                   
  return


def insert(name, username, pem_file):
  now = util.sysdate()

  if not os.path.isfile(pem_file):
    util.message("WARNING: pem_file not found", "info")

  sql = "INSERT INTO keys (name, username, pem_file, \n" + \
        "  created_utc, updated_utc) VALUES (%s, %s, %s, %s, %s)"

  rc = cloud.exec_sql(sql, [name, username, pem_file, now, now])

  return(rc)


def read(key_name):

  sql = "SELECT username, pem_file, \n" + \
        "       created_utc, updated_utc \n" + \
        "  FROM keys WHERE name = %s"

  data = cloud.exec_sql(sql, [key_name])
  return(str(data[0]), str(data[1]))


def update(name, username, pem_file):
  if not os.path.isfile(pem_file):
    util.message("WARNING: pem_file not found", "info")

  sql = "UPDATE keys SET username = %s, pem_file = %s, updated_utc = %s \n" + \
        " WHERE name = %s"

  rc =  cloud.exec_sql(sql, [username, pem_file, util.sysdate(), name])
  return(rc)


def delete(name):
  sql = "DELETE FROM keys WHERE name = %s"

  rc = cloud.exec_sql(sql, [name])
  return(rc)


def list():
  headers = ['Name', 'UserName', 'PemFile', 'Updated UTC ']
  keys    = ['name', 'username', 'pem_file', 'updated_utc']

  sql = "SELECT name, username, pem_file, updated_utc \n" + \
        "  FROM keys ORDER BY 1"

  data = cloud.exec_sql_list(sql)

  lst = []
  for d in data:
    dict = {}
    dict['name'] = str(d[0])
    dict['username'] = str(d[1])
    dict['pem_file'] = str(d[2])
    dict['updated_utc'] = str(d[3])

    lst.append(dict)

  util.print_list(headers, keys, lst)

  return



keyAPIs = {
  'list-cloud-keys': list_cloud_keys,
  'import-from-file': import_from_file,
  'destroy': destroy,
  'insert': insert,
  'list': list,
  'update': update,
  'delete': delete
}

if __name__ == '__main__':
  fire.Fire(keyAPIs)
