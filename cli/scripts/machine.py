#########################################################
#  Copyright 2020-2021  PGSQL.IO   All rights reserved. #
#########################################################

import util, meta, api, cloud
import sys, json, os, configparser, jmespath, munch
from pprint import pprint

import libcloud, fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def action(cloud_name, machine_id, action):

  try:
    driver = cloud.get_cloud_driver(cloud_name)
    if driver == None:
      return

    nodes = driver.list_nodes()
    for n in nodes:
      if n.id == machine_id:
        if action == "destroy":
          ret = n.destroy()
        elif action == "start":
          ret = driver.ex_start_node(n)
        elif action == "stop":
          ret = driver.ex_stop_node(n)
        elif action == "reboot":
          ret = n.reboot()
        else:
          util.message("Invalid action (" + str(action) + ") for NODE", "error")

        return(ret)

    util.message("Node not found", "error")

  except Exception as e:
    util.message(str(e), "error")
    return

  return


def destroy(cloud, machine_id):
  return(action(cloud, machine_id, "destroy"))


def start(cloud, machine_id):
  return(action(cloud, machine_id, "start"))


def stop(cloud, machine_id):
  return(action(cloud, machine_id, "stop"))


def reboot(cloud, machine_id):
  return(action(cloud, machine_id, "reboot"))


def launch(cloud_name, name, size, key, location=None, security_group=None, \
           network=None, data_gb=None):

  try:                                                                             
    driver = cloud.get_cloud_driver(cloud_name)
    if driver == None:
      util.message("not found in machine.launch() cloud.get_cloud_driver()", "error")
      return(None)

    sizes = driver.list_sizes()
    for s in sizes:
      if s.name == size:
        sz = s
        break
    else:
      util.message("Invalid Size (" + str(size) + ")", "error")
      return
    
    images = driver.list_images()
    for i in images:
      if i.name == 'CentOS-8':
        im = i
        break
    else:
      util.message("Cannot Locate 'Centos-8' image to use", "error")
      return(None)

    node = driver.create_node (name=name, size=sz, image=im, ex_keyname=key, \
       ex_config_drive=True, \
       ex_security_groups=driver.ex_list_security_groups(), \
       networks=driver.ex_list_networks())                                                    
    ##print("DEBUG: node  = " + str(node))
  except Exception as e:                                                           
    util.message(str(e), "error")
    return(None)

  machine_id = node.id
  ##print("DEBUG: machine_id = " + str(machine_id))
  return(machine_id)


# retrieve an aws-ec2 node using default credentials
def describe_aws(id):
  import boto3

  try:
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances(InstanceIds=[id])
  except Exception as e:                                                           
    return ('','','','','','','','','','')

  s = jmespath.search("Reservations[].Instances[].[InstanceId, InstanceType, State.Name, \
    Placement.AvailabilityZone, PrivateIpAddress, PublicIpAddress, KeyName, \
    [Tags[?Key=='Name'].Value] [0][0], CpuOptions.CoreCount, \
    BlockDeviceMappings[].Ebs[].VolumeId[] ] | [0]", response)

  id = s[0]
  flavor = s[1]
  state = s[2]
  loct = s[3]
  priv_ip = s[4]
  pub_ip = s[5]
  key_nm = s[6]
  name = s[7]
  vcpus = s[8]
  volumes = s[9]

  return (name, flavor, state, loct, priv_ip, pub_ip, key_nm, vcpus, volumes)


def describe_openstack(id):
  import openstack

  openstack.enable_logging(debug=False)

  conn = openstack.connect(load_envvars=True)

  for s in conn.list_servers():
    if s.id == id:
      try:
        volume = s.volumes[0].id
      except:
        volume = ""
      return (s.name, s.flavor.original_name, s.vm_state, s.region, \
        s.private_v4, s.public_v4, s.key_name, s.flavor.vcpus, volume)
  
  util.message("not found in describe_openstack() for " + str(id), "error")
  return ('','','','','','','','','')


def describe(cloud_name, id, print_list=True):
  provider = cloud.get_provider(cloud_name)
  if provider == 'aws':
    name, size, state, location, private_ip, \
    public_ip, key_name, vcpus, volumes \
      = describe_aws(id)
  elif provider in ('pgsql', 'openstack')  :
    name, size, state, location, private_ip, \
    public_ip, key_name, vcpus, volumes \
      = describe_openstack(id)
  else:
    util.message('Invalid Cloud type', 'error')
    return
    
  if name == '' and size == '':
    return

  headers = ['Name', 'Size',   'State', 'Location', 'PublicIp', 'Id']
  keys = ['name', 'size', 'state', 'location', 'public_ip', 'id']

  jsonList = []
  dict = {}
  dict['name'] = name
  dict['id'] = id
  dict['size'] = size
  dict['state'] = state
  dict['location'] = location
  dict['private_ip'] = private_ip
  dict['public_ip'] = public_ip
  dict['key_name'] = key_name
  dict['vcpus'] = str(vcpus)
  dict['volumes'] = volumes
  jsonList.append(dict)

  if print_list:
    util.print_list(headers, keys, jsonList)
    return

  return(str(jsonList))


def list(cloud_name):
  driver = cloud.get_cloud_driver(cloud_name)
  if driver == None:
    return
  
  try:                                                                             
    nodes = driver.list_nodes()
  except Exception as e:
    util.message(str(e), 'error')
    return

  headers = ['Name', 'ID', 'State', 'Public IP', 'Private IP']
  keys    = ['name', 'id', 'state', 'public_ip', 'private_ip']
                                                                                   
  jsonList = []                                                                    
                                                                                   
  for node in nodes:
    nodeDict = {}
    nodeDict['id'] = str(node.id)
    nodeDict['name'] = str(node.name)
    nodeDict['state'] = str(node.state)

    if len(node.public_ips) >= 1:
      nodeDict['public_ip'] = str(node.public_ips[0])
    else:
      nodeDict['public_ip'] = ""

    if len(node.private_ips) >= 1:
      nodeDict['private_ip'] = str(node.private_ips[0])
    else:
      if len(node.public_ips) >= 1:
        nodeDict['private_ip'] = str(node.public_ips[0])
      else:
        nodeDict['private_ip'] = ""

    jsonList.append(nodeDict)
                                                                                   
  if os.getenv("isJson", None):                                                    
    print(json.dumps(jsonList, sort_keys=True, indent=2))                          
  else:                                                                            
    print(api.format_data_to_table(jsonList, keys, headers))                       
                                                                                   
  return


def list_sizes(cloud_name):
  driver = cloud.get_cloud_driver(cloud_name)
  if driver == None:
    return

  try:
    sizes = driver.list_sizes()                                                    
  except Exception as e:                                                           
    util.message(str(e), 'error')
    return

  headers = ['Family', 'Size', 'RAM (MB)', 'Disk (GB)', 'Bandwidth', 'Price (USD/Mo)']
  keys    = ['family', 'size', 'ram', 'disk', 'bandwidth', 'price']
                                                                                   
  jsonList = []

  for size in sizes:
    if size.disk == 0:
      continue

    sz = size.name
    sz_split = sz.split(".")
    if len(sz_split) < 2:
      family = ""
      szz = size.name
    else:
      family = sz_split[0]
      szz = sz_split[1]
      
    sizeDict = {}
    sizeDict['family'] = family
    sizeDict['size'] = szz
    sizeDict['ram'] = str(size.ram)
    sizeDict['disk'] = str(size.disk)

    if size.price == 0.0:
      sizeDict['price'] = ""
    else:
      sizeDict['price'] = str(round(size.price * 720))

    if size.bandwidth == None:
      sizeDict['bandwidth'] = ""
    else:
      sizeDict['bandwidth'] = str(size.bandwidth)

    jsonList.append(sizeDict)

  if os.getenv("isJson", None):                                                    
    print(json.dumps(jsonList, sort_keys=True, indent=2))                          
  else:                                                                            
    print(api.format_data_to_table(jsonList, keys, headers))                       

  return


def create(cloud_name, machine_name, size, key_name, location=None, security_group=None, \
           network=None, data_gb=None):

  now1 = util.sysdate()
  machine_id = launch(cloud_name, machine_name, size, key_name, \
    location=None, security_group=None, network=None, data_gb=None)
  if machine_id == None:
    return

  describe_info = describe(cloud_name, machine_id, False)

  sql = "INSERT INTO machines \n" + \
        "  (id, name, cloud, key_name, describe, tags, created_utc, updated_utc) \n" + \
        " VALUES (?,?,?,?,?,?,?,?)"
  meta.exec_sql(sql, [machine_id, machine_name, cloud_name, key_name, \
    describe_info, None, now1, util.sysdate()])

  return


def read(machine_id=None, cloud_name=None):
  where = "1 = 1"
  if machine_id:
    where = where + " AND id = '" + str(machine_id) + "'"
  if cloud_name:
    where = where + " AND cloud = '" + str(cloud_name) + "'"

  sql = "SELECT id, name, cloud, key_name, describe, tags, \n" + \
        "       created_utc, updated_utc \n" + \
        "  FROM machines WHERE " + where + " ORDER BY 3, 2"

  data = meta.exec_sql_list(sql)

  return(data)


def update(name, cloud_id, key_id, describe, tags):
  sql = "UPDATE machines SET name = ?, cloud = ?, key_name = ?, \n" + \
        "  describe = ?, tags = ?, update_utc = ?"
  meta.exec_sql(sql, [name, cloud, key_name, describe, tags, util.sysdate()])
  return


def delete(machine_id):
  sql = "DELETE FROM machines WHERE id = ?"
  meta.exec_sql(sql, [machine_id])
  return


machineAPIs = {
  'list-sizes': list_sizes,
  'launch': launch,
  'list': list,
  'describe': describe,
  'destroy': destroy,
  'stop': stop,
  'start': start,
  'reboot': reboot,
  'create': create,
  'read': read,
  'update': update,
  'delete': delete
}

if __name__ == '__main__':
  fire.Fire(machineAPIs)
