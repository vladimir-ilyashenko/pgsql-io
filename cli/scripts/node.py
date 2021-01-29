########################################################
#  Copyright 2020-2021  PGSQL.IO  All rights reserved. #
########################################################

import util, meta, api, cloud, machine, key
import sys, json, os, configparser, jmespath, munch, time

import libcloud, fire
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver


def shell_cmd(cloud_name, machine_id, cmd):
  from pssh.clients import ParallelSSHClient

  util.message("# " + str(cmd))

  aa, bb, cc, describe, ee, ff, gg = read(cloud_name, machine_id)
  key_name = describe['key_name']
  host = describe['public_ip']
  hosts = host.split()

  username, pkey = key.read(key_name)
  if username == None:
    util.message("key file not found", "error")
  else:
    util.message("host=" + str(hosts) + ", user=" + username + \
                 ", pkey=" + str(pkey), "info")

  client = ParallelSSHClient(hosts, user=username, pkey=pkey)

  output = client.run_command(cmd, use_pty=True, read_timeout=30)
  for host_out in output:
    try:
      for line in host_out.stdout:
        print(line)
    except:
      time.sleep(3)
      continue

  return


def install_io(cloud_name, machine_ids):

  #repo = util.get_value("GLOBAL", "REPO")
  repo = "https://pgsql-io-download.s3.amazonaws.com/REPO"

  cmd = 'python3 -c "$(curl -fsSL ' + repo + '/install.py)"'

  shell_cmd(cloud_name, machine_ids, cmd)

  return


def io_cmd(cloud_name, machine_ids, cmd):
  full_io_cmd = "pgsql/io " + cmd + " --json"
  ##util.message("running:  '" + full_io_cmd + "'\n   on machines " + str(machine_ids))
  result_json = shell_cmd(cloud_name, machine_ids, full_io_cmd)
  return(result_json)


def create(cloud_name, machine_id, cluster_name=None):

  describe = machine.describe(cloud_name, machine_id)
  print ("DEBUG: describe = " + str(describe))
  if describe == None:
    util.message("machine not found", "error")
    return(False)

  info = install_io(cloud_name, machine_id)
  print ("DEBUG: info = " + str(info))

  upsert(cloud_name, machine_id, cluster_name, describe, info)

  return(True)


def read(cloud_name, machine_id, cluster_name=None):
  where = "1 = 1"
  if cloud_name:
      where = where + " AND cloud = '" + str(cloud_name) + "'"
  if cluster_name:
      where = where + " AND cluster_name = '" + str(cluster_name) + "'"
  if machine_id:
      where = where + " AND machine_id = '" + str(machine_id) + "'"

  sql = "SELECT cloud, machine_id, cluster_name, \n" + \
          "     describe, info, created_utc, updated_utc \n" + \
          "  FROM nodes WHERE " + where + " ORDER BY 1, 2"
  
  data =  meta.exec_sql_list(sql)
  if data == [] or data == None:
    util.message("node not found", "error")
    return(None, None, None, None, None, None, None)

  describe = data[3]
  if describe:
    describe = eval(describe)

  info = data[4]
  if info:
    info = eval(info)


  return(str(data[0]), str(data[1]), str(data[2]), describe, info, str(data[5]), str(data[6]))


def upsert(cloud_name, machine_id, cluster_name=None, describe=None, info=None):

  sql = "SELECT count(*) FROM nodes WHERE machine_id = ?"
  data = meta.exec_sql(sql, [machine_id])
  kount = data[0]

  now = util.sysdate()
  if kount == 0:
    sql = "INSERT INTO nodes (cloud, machine_id, cluster_name, \n" + \
          "  describe, info, created_utc, updated_utc) \n" + \
          "VAlUES (?,?,?,?,?,?,?)"
    meta.exec_sql(sql, [cloud_name, machine_id, cluster_name, 
                  str(describe), str(info), now, now])
  else:
    sql = "UPDATE nodes SET cloud = ?, cluster_name = ?, describe = ?, \n" + \
          " info = ?, updated_utc = ? WHERE machine_id = ?"
    meta.exec_sql(sql, [cloud_name, cluster_name, describe, info, now, machine_id])

  return


def delete(machine_id):
  sql = "DELETE FROM nodes WHERE machine_id = ?"
  meta.exec_sql(sql, [node_id])
  return


nodeAPIs = {
  'create': create,
  'read': read,
  'upsert': upsert,
  'delete': delete,
  'install-io': install_io,
  'shell-cmd': shell_cmd,
  'io-cmd': io_cmd
}

if __name__ == '__main__':
  fire.Fire(nodeAPIs)
