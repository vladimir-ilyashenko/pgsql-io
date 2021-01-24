########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver

import util, meta
import sys, json, os, configparser
from pprint import pprint


def get_provider(cloud_name):
  data = read(cloud_name, True)
  if data == None:
    util.message("not found", "error")
    return None

  provider = str(data[0])

  return(provider)


def get_cloud_driver(cloud_name):

  data = read(cloud_name, True)
  if data == None:
    util.message("not found", "error")
    return

  provider = data[0]

  keys = data[3]
  lkey = keys.split()

  libcloud_provider = get_provider_constant(provider)
  if libcloud_provider == None:
    return None

  try:
    cls = get_driver(libcloud_provider)
    if libcloud_provider == Provider.EC2:
      driver = cls(lkey[0], lkey[1], region = lkey[2])

    elif libcloud_provider == Provider.OPENSTACK:
      driver = cls(lkey[0], lkey[1], ex_force_auth_url = lkey[2],
        ex_tenant_name = lkey[3], ex_force_auth_version='3.x_password')

    else:
      util.message("driver not found", "error")
      driver = "None"

  except Exception as e:
    util.message(str(e), "error")
    return(None)

  return(driver)


def get_provider_constant(p_provider):
  pp = p_provider.upper()
  
  if pp in ('AWS', 'EC2'):
    return(Provider.EC2)
  elif pp in ('PGSQL', 'OPENSTACK'):
    return(Provider.OPENSTACK)
  else:
    util.message("provider not supported", "error")
    return(None)

                                                                                   
def delete(cloud_id):
  sql = "DELETE FROM clouds WHERE id = ?"
  meta.exec_sql(sql, [cloud_id])
  return
                                                                                   
                                                                                   
def update(provider, name, region, cloud_id, keys):
  sql = "UPDATE clouds SET name = ?, provider = ?, region = ?, keys = ?, updated_utc = ? WHERE id = ?"
  meta.exec_sql(sql, [name, provider, region, keys, util.sysdate(), cloud_id])
  return
                                                                                   
                                                                                   
def create(provider, name, region, keys=None):

  lc_provider = get_provider_constant(provider)
  if lc_provider == None:
    util.message("invalid provider", "error")
    return

  if keys == None:
    if lc_provider == Provider.EC2:
      conf_f = os.getenv('HOME') + os.sep + ".aws" + os.sep + "config"
      msg = "Using [default] AWS credentials from file '" + conf_f + "'"
      util.message(msg)

      config = configparser.ConfigParser()
      config.read(conf_f)

      key1 = config['default']['aws_access_key_id']
      key2 = config['default']['aws_secret_access_key']
      key3 = region

      keys = key1 + " " + key2 + " " + key3

    elif lc_provider == Provider.OPENSTACK:
      util.message("Using OpenStack environment variables:")

      key1 = os.getenv('OS_USERNAME', "x")
      if key1 == "x":
         util.message("OS_USERNAME not found.", "error")
         return

      key2 = os.getenv('OS_PASSWORD', "x")
      key3 = os.getenv('OS_AUTH_URL', "x")
      key4 = os.getenv('OS_TENANT_NAME', "x")

      keys = key1 + " " + key2 + " "+  key3 + " " + key4

    sql = "INSERT INTO clouds (id, name, provider, region, keys, created_utc, updated_utc) \n" + \
          "  VALUES (?, ?, ?, ?, ?, ?, ?)"
    now = util.sysdate()
    cloud_id = util.get_uuid()
    meta.exec_sql(sql, [cloud_id, name, provider, region, keys, now, now])

    util.message(cloud_id, "info")
    return 

  return

                                                                                   
def read(cloud_name=None, data_only=False):
  headers = ['Provider', 'Name', 'Region', 'ID']
  keys = ['provider', 'name', 'region', 'id']

  where = ""
  if cloud_name:
    where = "WHERE name =  '" + cloud_name + "'"

  sql = "SELECT provider, name, region, id, keys \n" + \
        "  FROM clouds " + where + " ORDER BY 1, 2"
  data = meta.exec_sql_list(sql)

  if data_only:
    for d in data:
      return str(d[0]), str(d[1]), str(d[2]), str(d[3], str(d[4]))
    return None

  jsonList = []
  for d in data:
    dict = {}
    dict['provider'] = str(d[0])
    dict['name'] = str(d[1])
    dict['region'] = str(d[2])
    dict['id'] = str(d[3])
    dict['keys'] = str(d[4])
    jsonList.append(dict)

  util.print_list(headers, keys, jsonList)

  return


def read_providers(status=None):
  headers = ['Type',          'Provider', 'Short Name', 'Display Name', 'Status']
  keys    = ['provider_type', 'provider', 'short_name', 'display_name', 'status']

  if status  == None:
    where = "1 = 1"
  else:
    where = "status  = '" + status + "'"

  sql = "SELECT provider, provider_type, sort_order, status, \n" + \
        "       short_name, disp_name \n" + \
        "  FROM providers WHERE " + where + " ORDER BY 2, 3"

  data = meta.exec_sql_list(sql)

  l_prov = []
  for d in data:
    dict = {}
    dict['provider'] = str(d[0])
    dict['provider_type'] = str(d[1])
    dict['status'] = str(d[3])
    dict['short_name'] = str(d[4])
    dict['display_name'] = str(d[5])

    l_prov.append(dict)

  util.print_list(headers, keys, l_prov)

  return


def read_locations(provider=None, country=None, metro=None):
  headers = ['Country', 'Area', 'Metro', 'Provider', 'Region', 'Location', 'Is Pref']
  keys  = ['country', 'area', 'metro', 'provider', 'region', 'location', 'is_preferred']

  where = "1 = 1"
  if provider:
    where = where + " AND provider = '" + provider + "'"
  if country:
    where = where + " AND country = '" + country + "'"
  if metro:
    where = where + " AND metro = '" + metro + "'"

  sql = "SELECT country, area, metro, provider, \n" + \
        "       region, location, is_preferred \n" + \
        "  FROM v_locations WHERE " + where

  data = meta.exec_sql_list(sql)

  l_lcn = []
  for d in data:
    dict = {}
    dict['country'] = str(d[0])
    dict['area'] = str(d[1])
    dict['metro'] = str(d[2])
    dict['provider'] = str(d[3])
    dict['region' ] = str(d[4])
    dict['location' ] = str(d[5])
    dict['is_preferred' ] = str(d[6])
    l_lcn.append(dict)

  util.print_list(headers, keys, l_lcn)

  return


def read_regions(provider=None, country=None, metro=None):
  headers = ['Country', 'Area', 'Metro Name', 'Metro', 'Provider', 'Region']
  keys  = ['country', 'area', 'metro_name', 'metro', 'provider', 'region']

  where = "1 = 1"
  if provider:
    where = where + " AND provider = '" + provider + "'"
  if country:
    where = where + " AND country = '" + country + "'"
  if metro:
    where = where + " AND metro = '" + metro + "'"

  sql = "SELECT country, area, metro_name, metro, provider, region" + \
        "  FROM v_regions WHERE " + where

  data = meta.exec_sql_list(sql)

  l_rgn = []
  for d in data:
    dict = {}
    dict['country'] = str(d[0])
    dict['area'] = str(d[1])
    dict['metro_name'] = str(d[2])
    dict['metro'] = str(d[3])
    dict['provider'] = str(d[4])
    dict['region' ] = str(d[5])
    l_rgn.append(dict)

  util.print_list(headers, keys, l_rgn)

  return


def read_images():
  headers = ['OS', 'Image Type', 'Disp Name', 'Cloud', 'Region', 'Platform', 'Image Name']
  keys = ['os', 'image_type', 'disp_name', 'cloud', 'region', 'platform', 'image_name']

  sql = "SELECT os, image_type, disp_name, cloud, region, platform, image_name \n" + \
        "  FROM v_images"

  data = meta.exec_sql_list(sql)

  l_img = []
  for d in data:
    dict = {}
    dict['os'] = str(d[0])
    dict['image_type'] = str(d[1])
    dict['disp_name'] = str(d[2])
    dict['cloud'] = str(d[3])
    dict['region'] = str(d[4])
    dict['platform'] = str(d[5])
    dict['image_name'] = str(d[6])
    l_img.append(dict)

  util.print_list(headers, keys, l_img)

  return


def read_services():
  headers = ['Group', 'Type', 'Type Name', 'Service', 'Service Name', 'Status']
  keys    = ['svc_group', 'svc_type', 'svc_type_name', 'service', 
             'svc_disp_name', 'status']

  sql = "SELECT svc_group, svc_type, svc_type_name, \n" + \
        "       service, svc_disp_name, status \n" + \
        "  FROM v_services"

  data = meta.exec_sql_list(sql)

  l_svc = []
  for d in data:
    dict = {}
    dict['svc_group'] = str(d[0])
    dict['svc_type'] = str(d[1])
    dict['svc_type_name'] = str(d[2])
    dict['service'] = str(d[3])
    dict['svc_disp_name'] = str(d[4])
    dict['status'] = str(d[5])
    l_svc.append(dict)

  util.print_list(headers, keys, l_svc)

  return


def read_flavors(provider=None, family=None, flavor=None, size=None):
  keys = ['provider', 'family', 'flavor', 'size', 'v_cpu', 'mem_gb', 'das_gb', 'price_hr']
  headers = ['Provider', 'Family', 'Flavor', 'Size', 'vCPU', 'Mem GB', 'DAS GB', 'Price/hr']

  where = "1 = 1"
  if provider:
    where = where + " AND provider = '" + provider + "'"
  if family:
    where = where + " AND family = '" + family + "'"
  if flavor:
    where = where + " AND flavor = '" + flavor + "'"
  if size: 
    where = where + " AND size = '" + size + "'"

  sql = "SELECT provider, family, flavor, size, v_cpu, mem_gb, das_gb, price_hr \n" + \
        "  FROM flavors WHERE " + where + " ORDER BY provider, family, v_cpu"

  data = meta.exec_sql_list(sql)

  l_flv = []
  for d in data:
    dict = {}
    dict['provider'] = d[0]
    dict['family'] = d[1]
    dict['flavor'] = d[2]
    dict['size'] = d[3]
    dict['v_cpu'] = d[4]
    dict['mem_gb'] = d[5]
    dict['das_gb'] = d[6]
    dict['price_hr'] = d[7]
    l_flv.append(dict)

  util.print_list(headers, keys, l_flv)

  return


## MAINLINE ##########################################
cloudAPIs = {
  'create': create,
  'update': update,
  'delete': delete,
  'read': read,
  'read-providers': read_providers,
  'read-regions': read_regions,
  'read-locations': read_locations,
  'read-images': read_images,
  'read-flavors': read_flavors,
  'read-services': read_services
}

if __name__ == '__main__':
  fire.Fire(cloudAPIs)
