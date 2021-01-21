#################################################################
#  Copyright 2020-2021  PGSQL.IO  AGPLV3.  All rights reserved. #
#################################################################

import util, meta, api, cloud, machine
import sys, json, os, configparser, jmespath, munch

import libcloud, fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def get_machine_id(node_id):
  sql = "SELECT machine_id FROM machines \n" + \
        " WHERE node_id = " + str(node_id) + "'"

  data = meta.exec_sql_list(sql)
  for d in data:
    machine_id = str(d[0])
    return(machine_id)

  return(None)


def destroy(cloud, node_id):
  return(machine.action(cloud, get_machine_id(node_id), "destroy"))


def start(cloud, node_id):
  return(machine.action(cloud, get_machine_id(node_id), "start"))


def stop(cloud, node_id):
  return(machine.action(cloud, get_machine_id(node_id), "stop"))


def reboot(cloud, node_id):
  return(machine.action(cloud, get_machine_id(node_id), "reboot"))


def launch(cloud, name, size, key, location="", security_group="", 
           network="", wal_gb="", data_gb=""):
  return


def get_host_ips(machine_ids):
  sql = "SELECT describe FROM machines WHERE id = "
  host_ips = []
  ##print("DEBUG: machine_ids = " + str(machine_ids))
  machine_list = machine_ids.split(",")
  ##print("DEBUG: machine_list = " + str(machine_list))
  for machine in machine_list:
    sql1 = sql + "'" + machine + "'"
    ##print("DEBUG: sql1 = " + sql1)
    data = meta.exec_sql_list(sql1)
    ##print("DEBUG: data = " + str(data))
    if data == None or data == []:
      util.message("not found", "error")
      return(None)
    for d in data:
      describe_info = d[0]
    describe_info = describe_info.replace("[", "")
    describe_info = describe_info.replace("]", "")
    describe_info = describe_info.replace("'", '"')
    ##print("DEBUG: describe_info = " + str(describe_info))
    dict = json.loads(describe_info)
    public_ip = dict["public_ip"]
    ##print("DEBUG: public_ip = " + str(public_ip))
    host_ips.append(public_ip)

  ##print("DEBUG: host_ips = " + str(host_ips))
  return(host_ips)


def shell_cmd(machine_ids, cmd):
  from pssh.clients import ParallelSSHClient

  hosts = get_host_ips(machine_ids)

  client = ParallelSSHClient(hosts, user="centos", pkey="~/keys/denisl-pubkey.pem")

  output = client.run_command(cmd)
  client.join(output)
  for host_out in output:
    for line in host_out.stdout:
      print(line)

  return


def install_io(machine_ids):
  util.message("installing pre-req's", "info")
  shell_cmd(machine_ids, "sudo yum install -y python3 python3-devel wget curl")

  #repo = util.get_value("GLOBAL", "REPO")
  repo = "https://pgsql-io-download.s3.amazonaws.com/REPO"

  cmd = 'python3 -c "$(curl -fsSL ' + repo + '/install.py)"'
  util.message("installing IO with " + str(cmd) , "info")

  shell_cmd(machine_ids, cmd)

  return


def io_cmd(machine_ids, cmd):
  full_io_cmd = "pgsql/io " + cmd + " --json"
  ##util.message("running:  '" + full_io_cmd + "'\n   on machines " + str(machine_ids))
  result_json = shell_cmd(machine_ids, full_io_cmd)
  return(result_json)


def create(machine_id, cluster_name, current_role=None, components=None, info=None):

  rc = install_io(machine_id)

  now = util.sysdate()
  sql = "INSERT INTO nodes (machine_id, cluster_name, current_role, \n" + \
        "  components, info, created_utc, updated_utc) \n" + \
        "VAlUES (?,?,?,?,?,?,?)"

  meta.exec_sql(sql, [machine_id, cluster_name, current_role, components, info, now, now])
  return(node_id)


def read(node_id=None, cluster_id=None, machine_id=None):
  where = "1 = 1"
  if node_id:
    where = where + " AND id = '" + str(node_id) + "'"
  if cluster_id:
    where = where + " AND cluster_id = '" + str(cluster_id) + "'"
  if machine_id:
    where = where + " AND machine_id = '" + str(machine_id) + "'"

  sql = "SELECT id, name, machine_id, cluster_id, current_role, \n" + \
        "       components, info, created_utc, updated_utc \n" + \
        "  FROM nodes WHERE " + where + " ORDER BY cluster_id, name"

  data =  meta.exec_sql_list(sql)
  return(data)


def update(node_id, name, machine_id, cluster_id, current_role, components, info):
  sql = "UPDATE nodes SET name = ?, machine_id = ?, cluster_id = ?, current_role = ?, \n" + \
        "       components = ?, info = ?, updated_utc= ? \n" + \
        " WHERE id = ?"
  meta.exec_sql(sql,[name, machine_id, cluster_id, current_role, components, info, 
                    util.sysdate(), node_id])
  return


def delete(node_id):
  sql = "DELETE FROM nodes WHERE id = ?"
  meta.exec_sql(sql, [node_id])
  return


nodeAPIs = {
  'launch': launch,
  'destroy': destroy,
  'stop': stop,
  'start': start,
  'reboot': reboot,
  'create': create,
  'read': read,
  'update': update,
  'delete': delete,
  'install-io': install_io,
  'shell-cmd': shell_cmd,
  'io-cmd': io_cmd
}

if __name__ == '__main__':
  fire.Fire(nodeAPIs)
