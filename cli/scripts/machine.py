########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import util, meta, api, cloud, node
import sys, json, os, configparser, jmespath
import munch, time
from pprint import pprint

import libcloud, fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def action(cloud_name, machine_ids, action):

  try:
    driver = cloud.get_cloud_driver(cloud_name)
    if driver == None:
      return

    kount = 0
    nds = driver.list_nodes()
    for n in nds:
      if n.id in machine_ids:
        kount = kount + 1
        if action == "destroy":
          ret = n.destroy()
          node.delete(n.id)
        elif action == "start":
          ret = driver.ex_start_node(n)
        elif action == "stop":
          ret = driver.ex_stop_node(n)
        elif action == "reboot":
          ret = n.reboot()
        else:
          util.message("Invalid action (" + str(action) + ") for NODE", "error")

    if kount == 0:
      util.message("Node not found", "error")
      return

  except Exception as e:
    util.message(str(e), "error")
    return

  return


def get_machine_ids(cloud_name, machine_name):
  util.message("getting machine id's for " + str(machine_name))

  try:
    driver = cloud.get_cloud_driver(cloud_name)
    if driver == None:
      return

    machine_ids = ""
    kount = 0
    nds = driver.list_nodes()
    for n in nds:
      if n.name == machine_name:
        if machine_ids == "":
          machine_ids = str(n.id)
        else:
          machine_ids = machine_ids + ", " + str(n.id)
  except:
    util.message("error thrown in get_machine_ids()", "error")
    return(None)
  
  util.message('machine_ids = "' + str(machine_ids) + '"', 'info')
  return(machine_ids)


def destroy(cloud_name, machine_ids=None, machine_name=None):
  if machine_ids == None and machine_name == None:
    util.message("machines_ids or machine_name required", "error")
    return

  if machine_ids == None:
    machine_ids = get_machine_ids(cloud_name, machine_name)

  return(action(cloud_name, machine_ids, "destroy"))


def start(cloud, machine_ids):
  return(action(cloud, machine_ids, "start"))


def stop(cloud, machine_ids):
  return(action(cloud, machine_ids, "stop"))


def reboot(cloud, machine_ids):
  return(action(cloud, machine_ids, "reboot"))


def get_image(driver, cloud_name, platform='amd'):
  util.message("getting default image", "info")

  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  sql = "SELECT image_id, image_type FROM images \n" + \
        " WHERE provider = ? AND region = ? AND platform = ? AND is_default = 1"
  data = meta.exec_sql(sql,[provider, region, platform])
  if data == None or data == []:
    util.message("Image not known for " + str(cloud_name) + \
      ", " + str(region) + ", " + str(platform) + ")", "error")
    return(None, None)
    
  image_id = str(data[0])
  image_type = str(data[1])

  if provider == 'aws':
    images = driver.list_images(ex_image_ids=image_id.split())
  else:
    images = driver.list_images()

  for i in images:
    if i.id == image_id:
      util.message("image_id - " + image_type + " : " + image_id, "info")
      return(i, image_type)

  util.message("Cannot Locate image '" + str(image_id) + "'", "error")
  return(None, None)


def launch(cloud_name, size, name=None, key=None, location=None, security_group=None, \
           network=None, data_gb=None, wait_for=True):

  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  if key == None:
    key = default_ssh_key

  if name == None:
    machine_name = "?"
  else:
    machine_name = name 

  util.message("launching - " + str(cloud_name) + ", " + \
    str(size) + ", " + str(key))
  try:                                                                             
    driver = cloud.get_cloud_driver(cloud_name)
    if driver == None:
      util.message("cloud driver not found", "error")
      return(None)

    util.message("validating size - " + str(size), "info")
    sizes = driver.list_sizes()
    for s in sizes:
      if s.name == size:
        sz = s
        break
    else:
      util.message("Invalid Size - " + str(size), "error")
      return(None)
    
    im, typ = get_image(driver, cloud_name)
    if im == None:
      return(None)

    util.message("creating machine on " + str(provider), "info")
    if provider == 'aws':
      nd = driver.create_node (name=machine_name, size=sz, image=im, ex_keyname=key, \
        ex_security_groups=["default"])
    else:
      nd = driver.create_node (name=machine_name, size=sz, image=im, ex_keyname=key, \
        ex_config_drive=True, ex_security_groups=driver.ex_list_security_groups(), \
        networks=driver.ex_list_networks())                                                    
    
  except Exception as e:                                                           
    util.message(str(e), "error")
    return(None)

  machine_id = nd.id
  util.message("machine_id - " + str(machine_id), "info")

  if wait_for == True:
    waitfor(cloud_name, machine_id, "running")

  return(machine_id)


def waitfor(cloud_name, machine_id, new_state, interval=5, max_tries=12):
  util.message("waitfor '" + str(new_state) + "' up to " + str(interval * max_tries) + "s", "info")
  driver = cloud.get_cloud_driver(cloud_name)
  if driver == None:
    return

  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  kount = 0
  while kount < max_tries:
    name, size, state, location, private_ip, \
    public_ip, key_name, vcpus, volumes \
      = get_describe_data(provider, machine_id, region, cloud_keys)

    if (state == new_state) or (state == "active"):
      util.message("  " + new_state, "info")
      return(new_state)

    if state == "error":
      util.message(state, "error")
      return("error")

    util.message("  " + state, "info")
    kount = kount + 1
    time.sleep(interval)

  util.message("max tries exceeded", "error")
  return("error")


# retrieve an aws-ec2 node using default credentials
def describe_aws(machine_id, region, cloud_keys):
  ##util.message("ec2.describe_instances()", "info")
  import boto3

  l_cloud_keys = cloud_keys.split()

  try:
    ec2 = boto3.client('ec2', 
            aws_access_key_id=l_cloud_keys[0],
            aws_secret_access_key=l_cloud_keys[1],
            region_name=region)
    response = ec2.describe_instances(InstanceIds=machine_id.split())
  except Exception as e:                                                           
    util.message("not found in aws for " + str(machine_id), "error")
    return ('','','','','','','','','')

  ##util.message("jmespath.search()", "info")
  s = jmespath.search("Reservations[].Instances[].[InstanceId, InstanceType, State.Name, \
    Placement.AvailabilityZone, PrivateIpAddress, PublicIpAddress, KeyName, \
    [Tags[?Key=='Name'].Value] [0][0], CpuOptions.CoreCount, \
    BlockDeviceMappings[].Ebs[].VolumeId[] ] | [0]", response)

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


def describe_openstack(machine_id, region, l_cloud_keys):
  ##util.message("openstack.connect()", "info")
  import openstack
  openstack.enable_logging(debug=False)
  conn = openstack.connect(load_envvars=True)

  ##util.message("openstack.list_servers()", "info")
  for s in conn.list_servers():
    if s.id == machine_id:
      try:
        volume = s.volumes[0].id
      except:
        volume = ""

      if s.vm_state == "active":
        vm_state = "running"
      elif s.vm_state == "building":
        vm_state = "pending"
      else:
        vm_state = s.vm_state

      return (s.name, s.flavor.original_name, vm_state, s.region, \
        s.private_v4, s.public_v4, s.key_name, s.flavor.vcpus, volume)
  
  util.message("not found in openstack for " + str(machine_id), "error")
  return ('','','','','','','','','')


def get_describe_data(provider, machine_id, region, cloud_keys):
  if provider == 'aws':
    return (describe_aws(machine_id, region, cloud_keys))
  else:
    return (describe_openstack(machine_id, region, cloud_keys))


def describe(cloud_name, machine_id, print_list=True):
  provider, xxx, region, default_ssh_key, cloud_keys = cloud.read(cloud_name, True)

  name, size, state, location, private_ip, \
  public_ip, key_name, vcpus, volumes \
    = get_describe_data(provider, machine_id, region, cloud_keys)

  if state == '' or state == None:
    return(None)

  headers = ['Name', 'Size',   'State', 'Location', 'PublicIp', 'Id']
  keys = ['name', 'size', 'state', 'location', 'public_ip', 'id']

  jsonList = []
  dict = {}
  dict["name"] = name
  dict["id"] = machine_id
  dict["size"] = size
  dict["state"] = state
  dict["location"] = location
  dict["private_ip"] = private_ip
  dict["public_ip"] = public_ip
  dict["key_name"] = key_name
  dict["vcpus"] = str(vcpus)
  dict["volumes"] = volumes
  jsonList.append(dict)

  if print_list:
    util.print_list(headers, keys, jsonList)
    return(dict)

  return(dict)


def list(cloud_name):
  driver = cloud.get_cloud_driver(cloud_name)
  if driver == None:
    return
  
  try:                                                                             
    nds = driver.list_nodes()
  except Exception as e:
    util.message(str(e), 'error')
    return

  headers = ['Name', 'ID', 'State', 'Public IP', 'Private IP']
  keys    = ['name', 'id', 'state', 'public_ip', 'private_ip']
                                                                                   
  jsonList = []                                                                    
                                                                                   
  for nd in nds:
    ndDict = {}
    ndDict['id'] = str(nd.id)
    ndDict['name'] = str(nd.name)
    ndDict['state'] = str(nd.state)

    if len(nd.public_ips) >= 1:
      ndDict['public_ip'] = str(nd.public_ips[0])
    else:
      ndDict['public_ip'] = ""

    if len(nd.private_ips) >= 1:
      ndDict['private_ip'] = str(nd.private_ips[0])
    else:
      if len(nd.public_ips) >= 1:
        ndDict['private_ip'] = str(nd.public_ips[0])
      else:
        ndDict['private_ip'] = ""

    jsonList.append(ndDict)
                                                                                   
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


def create(cloud_name, size, machine_name=None, key_name=None,\
           location=None, security_group=None, network=None, data_gb=None):

  machine_id = launch(cloud_name, size, machine_name, key_name, \
    location=None, security_group=None, network=None, data_gb=None)
  if machine_id == None:
    return

  node.create(cloud_name, machine_id)

  return


def insert(cloud_name, machine_id, key_name=None):
  di = describe(cloud_name, machine_id, False)
  if di == None:
    util.message("invalid machine_id", "error")
    return

  now1 = util.sysdate()
  machine_name = di['name']

  sql = "INSERT INTO machines \n" + \
        "  (id, name, cloud, key_name, describe, tags, created_utc, updated_utc) \n" + \
        " VALUES (?,?,?,?,?,?,?,?)"

  ##print("DEBUG: machine.insert " + machine_id + ", " + machine_name + ", " + cloud_name + ", " + key_name + ", " + str(describe_info))
  meta.exec_sql(sql, [machine_id, machine_name, cloud_name, key_name, \
    str(di), None, now1, now1])

  return


def read(cloud_name=None, machine_id=None):
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


machineAPIs = {
  'list-sizes': list_sizes,
  'launch': launch,
  'list': list,
  'describe': describe,
  'destroy': destroy,
  'stop': stop,
  'start': start,
  'reboot': reboot,
  'create': create
}

if __name__ == '__main__':
  fire.Fire(machineAPIs)
