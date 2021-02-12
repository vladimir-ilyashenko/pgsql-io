########################################################
#  Copyright 2020-2021  OpenRDS  All rights reserved. #
########################################################

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver
from dotenv import load_dotenv


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

  keys = data[4]
  lkey = keys.split()

  libcloud_provider = get_provider_constant(provider)
  if libcloud_provider == None:
    return None

  try:
    cls = get_driver(libcloud_provider)
    if libcloud_provider == Provider.EC2:
      driver = cls(lkey[0], lkey[1], region = lkey[2])

    elif libcloud_provider == Provider.OPENSTACK:
      load_dotenv(dotenv_path=keys)
      username = os.getenv("OS_USERNAME", "")
      passwd = os.getenv("OS_PASSWORD", "")
      auth_url = os.getenv("OS_AUTH_URL", "")
      project  = os.getenv("OS_PROJECT_NAME", "")
      driver = cls(username, passwd, ex_force_auth_url = auth_url,
        ex_tenant_name = project, ex_force_auth_version='3.x_password')

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
  elif pp in ('OPENRDS', 'OPENSTACK'):
    return(Provider.OPENSTACK)
  else:
    util.message("provider not supported", "error")
    return(None)

                                                                                   
def delete(cloud_name):
  sql = "DELETE FROM clouds WHERE name = ?"
  meta.exec_sql(sql, [cloud_name])
  return
                                                                                   
                                                                                   
def update(cloud_name, provider, region, keys):
  sql = "UPDATE clouds SET provider = ?, region = ?, keys = ?, updated_utc = ? WHERE name = ?"
  meta.exec_sql(sql, [provider, region, keys, util.sysdate(), cloud_name])
  return
                                                                                   
                                                                                   
def create(provider, name=None, region=None, keys=None, default_ssh_key=None):
  if name == None:
    name = provider

  lc_provider = get_provider_constant(provider)
  if lc_provider == None:
    util.message("invalid provider", "error")
    return

  if lc_provider == Provider.OPENSTACK:
    if region == None:
      util.message("region must be specied", "error")
      return

    if keys == None:
      util.message("env file must be specified as key", "error")
      return

    if not os.path.isfile(keys):
      util.message("invalid env file specified as key", "error")
      return

  if keys == None and lc_provider == Provider.EC2:
    conf_f = os.getenv('HOME') + os.sep + ".aws" + os.sep + "config"
    util.message("Using [default] AWS credentials from file " + conf_f, "info")

    config = configparser.ConfigParser()
    config.read(conf_f)

    key1 = config['default']['aws_access_key_id']
    key2 = config['default']['aws_secret_access_key']

    if region == None:
      region = config['default']['region']
    key3 = region

    keys = key1 + " " + key2 + " " + key3

  sql = "INSERT INTO clouds (name, provider, region, keys, default_ssh_key, " + \
        "  created_utc, updated_utc) \n" + \
        "VALUES (?, ?, ?, ?, ?, ?, ?)"
  now = util.sysdate()
  meta.exec_sql(sql, [name, provider, region, keys, default_ssh_key, now, now])

  return


def list():
  read(None, False)
  return

                                                                                   
def read(cloud_name=None, data_only=False):
  headers = ['Provider', 'Name', 'Region', 'Default SSH Key']
  keys = ['provider', 'name', 'region', 'default_ssh_key']

  where = ""
  if cloud_name:
    where = "WHERE name =  '" + cloud_name + "'"

  sql = "SELECT provider, name, region, default_ssh_key, keys \n" + \
        "  FROM clouds " + where + " ORDER BY 1, 2"
  data = meta.exec_sql_list(sql)

  if data_only:
    for d in data:
      if d[3] == None:
        default_ssh_key = ""
      else:
        default_ssh_key = str(d[3])
      return str(d[0]), str(d[1]), str(d[2]), default_ssh_key, str(d[4])
    return None

  jsonList = []
  for d in data:
    if d[3] == None:
      default_ssh_key = ""
    else:
      default_ssh_key = str(d[3])

    dict = {}
    dict['provider'] = str(d[0])
    dict['name'] = str(d[1])
    dict['region'] = str(d[2])
    dict['default_ssh_key'] = default_ssh_key
    dict['keys'] = str(d[4])
    jsonList.append(dict)

  util.print_list(headers, keys, jsonList)

  return


def list_providers(status=None):
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


def list_locations(provider=None, country=None, metro=None):
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


def list_regions(provider=None, country=None, metro=None):
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


def list_images():
  headers = ['OS', 'Image Type', 'DispName', 'Provider', 'Region', 'Platform', 'IsDefault', 'ImageID']
  keys = ['os', 'image_type', 'disp_name', 'provider', 'region', 'platform', 'is_default', 'image_id']

  sql = "SELECT os, image_type, disp_name, provider, region, platform, is_default, image_id \n" + \
        "  FROM v_images"

  data = meta.exec_sql_list(sql)

  l_img = []
  for d in data:
    dict = {}
    dict['os'] = str(d[0])
    dict['image_type'] = str(d[1])
    dict['disp_name'] = str(d[2])
    dict['provider'] = str(d[3])
    dict['region'] = str(d[4])
    dict['platform'] = str(d[5])
    dict['is_default'] = str(d[6])
    dict['image_id'] = str(d[7])
    l_img.append(dict)

  util.print_list(headers, keys, l_img)

  return


def list_flavors(provider=None, family=None, flavor=None, size=None):
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
        "  FROM flavors WHERE " + where + " ORDER BY provider, v_cpu"

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


def get_aws_connection(svc, region, cloud_keys):
  import boto3

  l_cloud_keys = cloud_keys.split()

  try:
    conn = boto3.client(svc,
            aws_access_key_id=l_cloud_keys[0],
            aws_secret_access_key=l_cloud_keys[1],
            region_name=region)

  except Exception as e:
    util.message("error in cloud.get_aws_connection():\n " + str(e), "error")
    conn = None

  return(conn)


def get_openstack_connection(region, cloud_keys):
  import openstack

  try:
    load_dotenv(dotenv_path=cloud_keys)
    openstack.enable_logging(debug=False)
    conn = openstack.connect(load_envvars=True)

  except Exception as e:
    util.message(str(e), "error")
    return(None)

  return(conn)


## MAINLINE ##########################################
cloudAPIs = {
  'create': create,
  'update': update,
  'delete': delete,
  'list': list,
  'list-providers': list_providers,
  'list-regions': list_regions,
  'list-locations': list_locations,
  'list-images': list_images,
  'list-flavors': list_flavors
}

if __name__ == '__main__':
  fire.Fire(cloudAPIs)
