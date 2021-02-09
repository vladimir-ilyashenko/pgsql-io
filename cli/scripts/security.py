########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import util, meta, api, cloud, node

import sys, json, os, configparser

import libcloud
import fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def list():
  headers = ['Group', 'Type', 'Type Name', 'Service', 'Port', 'Image', 'Project URL', 'Description']
  keys    = ['svc_group', 'svc_type', 'svc_type_name', 'service', 'port', 'image_file', 'project_url', 'description']

  sql = "SELECT svc_group, svc_type, svc_type_name, service, \n" + \
        "       port, image_file, project_url, description \n" + \
        "  FROM v_services"

  data = meta.exec_sql_list(sql)

  l_svc = []
  for d in data:
    dict = {}
    dict['svc_group'] = str(d[0])
    dict['svc_type'] = str(d[1])
    dict['svc_type_name'] = str(d[2])
    dict['service'] = str(d[3])
    dict['port'] = str(d[4])
    dict['image_file'] = str(d[5])
    dict['project_url'] = str(d[6])
    dict['description'] = str(d[7])
    l_svc.append(dict)

  util.print_list(headers, keys, l_svc)

  return


def group_list(cloud_name, group_name=None, data_only=False):
  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  if provider == "aws":
    gl = group_list_aws(region, cloud_keys, group_name)
  else:
    gl = group_list_openstack(region, cloud_keys, group_name)

  if data_only == True:
    return(gl)

  headers = ['ID', 'Cidr', 'Port', 'Name']
  keys = ['id', 'cidr', 'port', 'name']

  util.print_list(headers, keys, gl)

  return


def group_list_aws(region, cloud_keys, group_name=None):
  conn = cloud.get_aws_connection('ec2', region, cloud_keys)
  if conn == None:
    return ([])

  import boto3
  try:
    response = conn.describe_security_groups()
  except Exception as e:
    util.message(str(e), "error")
    return ([])

  gl = []
  for sg in response['SecurityGroups']:
   try:
    dict = {}
    if group_name:
      if sg['GroupName'] == group_name:
        pass
      else:
        continue

    dict['name'] = sg['GroupName']
    dict['id']  = sg['GroupId']
    for ipp in sg['IpPermissions']:
      for r in ipp['IpRanges']:
        dict['cidr'] = str(r['CidrIp'])
        break
      dict['port'] = str(ipp['FromPort']) + ":" + str(ipp['ToPort'])       
      break
    gl.append(dict)
   except Exception as e:
    continue

  return(gl)


def rule_create_openstack(region, cloud_keys, group_nm, port, cidr):
  conn = cloud.get_openstack_connection(region, cloud_keys)
  if conn == None:
    return([])

  sg_rule = None
  try:
    import openstack
    sg_rule = conn.create_security_group_rule(group_nm, port_range_min=port, 
                port_range_max=port, protocol="tcp", remote_ip_prefix=cidr )
  except Exception as e:
    util.message(str(e), "error")
    return(None)

  return(sg_rule)


def group_create_openstack(region, cloud_keys, gp_name, gp_description="_"):
  conn = cloud.get_openstack_connection(region, cloud_keys)
  if conn == None:
    return([])

  sg_id = None
  try:
    util.message("creating security group", "info")
    import openstack
    sg_id = conn.create_security_group(gp_name, gp_description)
  except Exception as e:
    util.message(str(e), "error")
    return(None)

  return(sg_id)


def group_list_openstack(region, cloud_keys, group_name=None):
  conn = cloud.get_openstack_connection(region, cloud_keys)
  if conn == None:
    return([])

  import openstack
  gl = []
  for sg in conn.list_security_groups():
    try:
      dict = {}
      if group_name:
        if sg.name == group_name:
          pass
        else:
          continue

      dict['name'] = sg.name
      dict['id'] = sg.id
      rules = sg.security_group_rules
      port = None
      for rule in rules:
        if rule['direction'] == "ingress" and rule['protocol'] == "tcp":
          dict['cidr'] = str(rule['remote_ip_prefix'])
          dict['port'] = str(rule['port_range_min']) + ":" + str(rule['port_range_min'])
          break
        else:
          continue
      gl.append(dict)
    except Exception as e:
      ## skip rules we cannot parse
      continue

  return(gl)


def get_service_port(service):
  return(5432)


def get_unique_name(service, group_list):
  wiz_prefix = "openrds-sg-wizard-" + service + "-"
  len_prefix = len(wiz_prefix)
  wiz_max = 0

  for gp in group_list:
    name = str(gp['name'])
    if name.startswith(wiz_prefix):
      wiz_num = name[len_prefix:]
      try:
        wiz_num = int(wiz_num)
      except:
        # ignore names that dont fit the pattern
        continue
      if wiz_num > wiz_max:
        wiz_max = wiz_num

  wiz_name = wiz_prefix + str(wiz_max + 1)
  util.message("new security group name = " + str(wiz_name))
  return(wiz_name)


def rule_create(cloud_name, group_id, port, cidr="0.0.0.0/0"):
  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  if provider == "aws":
    rule_id = rule_create_aws(region, cloud_keys, group_id, port, cidr)
  else:
    rule_id = rule_create_openstack(region, cloud_keys, group_id, port, cidr)

  return(rule_id)


def rule_delete(cloud_name, group_id, rule_id):
  return(None)


# create a new security group with a single rule in it
def group_create(cloud_name, service, port=None, cidr="0.0.0.0/0"):
  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  group_name = get_unique_name(service, group_list(cloud_name, data_only=True))

  if provider == "aws":
    group_id = group_create_aws(region, cloud_keys, group_name)
  else:
    group_id = group_create_openstack(region, cloud_keys, group_name)

  if group_id == None:
    return

  ##util.message("group_id = " + str(group_id))

  if port == None:
    port = get_service_port(service)
    util.message("port = "  + str(port), "info")

  rule_create(cloud_name, group_id, port, cidr="0.0.0.0/0")

  return(group_id)


def group_delete(cloud_name, group_name=None, group_id=None):
  if ((group_id == None and group_name == None) or
      (group_id and group_name)):
    util.message("Must specify group_id or group_name", "error")
    return

  return


secAPIs = {
  'group-list': group_list,
  'group-create': group_create,
  'group-delete': group_delete,
  'rule-create': rule_create,
  'rule-delete': rule_delete
}

if __name__ == '__main__':
  fire.Fire(secAPIs)
