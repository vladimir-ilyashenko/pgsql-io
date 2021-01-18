###############################################################
#  Copyright 2020-2021  PGSQL.  AGPLV3.  All rights reserved. #
###############################################################

import util, meta, api

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def import_from_file(cloud, name, pub_key_file):
  try:
    driver = util.get_cloud_driver(cloud)                                          
    driver.import_key_pair_from_file(name, pub_key_file)                                                    
  except Exception as e:                                                           
    util.fatal_error(str(e))


def destroy(cloud, name):
  try:
    driver = util.get_cloud_driver(cloud)                                          
    key = driver.get_key_pair(name)
    driver.delete_key_pair(key)                                                    
  except Exception as e:                                                           
    util.fatal_error(str(e))


def list(cloud):                                                  
  try:
    driver = util.get_cloud_driver(cloud)                                          
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


def create(name, username, pub_key_path, priv_key_path):
  now = util.sysdate()
  key_id = util.get_uuid()
  sql = "INSERT INTO keys (id, name, username, pub_key_path, priv_key_path, \n" + \
        "  created_utc, updated_utc) VALUES (?,?,?,?,?,?,?)"
  meta.exec_sql(sql, [key_id, name, username, pub_key_path, priv_key_path, now, now])
  return(key_id)


def read(key_id=None):

  if key_id == None:
    where = "1 = 1"
  else:
    where = "id = '" + str(key_id) + "'"

  sql = "SELECT id, name, username, pub_key_path, priv_key_path, \n" + \
        "       created_utc, updated_utc \n" + \
        "  FROM keys WHERE " + where + " ORDER BY 2, 3"

  data = meta.exec_sql_list(sql)
  return(data)


def update(key_id, name, username, pub_key_path, priv_key_path):
  sql = "UPDATE keys SET name = ?, username = ?, pub_key_path = ?, \n" + \
        "       priv_key_path = ?, updated_utc = ? \n" + \
        " WHERE id = ?"
  meta.exec_sql(sql, \
    [name, username, pub_key_path, priv_key_path, util.sysdate(), key_id])
  return


def delete(key_id):
  sql = "DELETE FROM keys WHERE id = ?"
  meta.exec_sql(sql, [key_id])
  return


keyAPIs = {
  'list': list,
  'import-from-file': import_from_file,
  'destroy': destroy,
  'create': create,
  'read': read,
  'update': update,
  'delete': delete
}

if __name__ == '__main__':
  fire.Fire(keyAPIs)
