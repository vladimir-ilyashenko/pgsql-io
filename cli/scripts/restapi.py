import flask, os, subprocess
from flask import request, jsonify
from subprocess import Popen, PIPE, STDOUT

import sys, json

import util, api

io_cmd = os.getenv('MY_HOME') + os.sep + os.getenv('MY_CMD')

app = flask.Flask(__name__)


def sys_cli(p_cmd): 
  cmd = io_cmd + " " + p_cmd + " --json"
  print("DEBUG: " + str(cmd))
  p = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE, executable=None, close_fds=False)
  (out, err) = p.communicate()

  try:
    s_out = out.decode("utf-8").rstrip()
    j_out = json.loads(s_out)
  except Exception:
    try:
      dList = []
      for line in s_out.splitlines():
        print(json.dumps(line))
        dList.append(json.loads(line))
      j_out = dList
    except Exception:
      j_out = {"bad json": str(s_out)}

  return(j_out)


@app.route('/', methods=['GET'])
def home():
    return '''<h1>OpenRDS REST API</h1>
<p>A REST API for "io" commands</p>'''


@app.route('/info', methods=['GET'])
def info():
  inf = sys_cli("info")
  return(jsonify(inf))


@app.route('/cloud/create', methods=['GET'])
def cloud_create():
  prv = request.args.get('provider')
  if prv in (None, ""):
    j = util.message("'provider' parm required.", "ERROR", True)
    return(jsonify(j))
    
  i = sys_cli("cloud create " + prv)
  return ({"more work to do here"})


@app.route('/cloud/list', methods=['GET'])
def cloud_list():
  i = sys_cli("cloud list")
  return(jsonify(i))


@app.route('/cloud/list/providers', methods=['GET'])
def cloud_list_providers():
  i = sys_cli("cloud list-providers")
  return(jsonify(i))


@app.route('/cloud/list/regions', methods=['GET'])
def cloud_list_regions():
  i = sys_cli("cloud list-regions")
  return(jsonify(i))


@app.route('/cloud/list/locations', methods=['GET'])
def cloud_list_locations():
  i = sys_cli("cloud list-locations")
  return(jsonify(i))


@app.route('/cloud/list/flavors', methods=['GET'])
def cloud_list_flavors():
  i = sys_cli("cloud list-flavors")
  return(jsonify(i))


@app.route('/cloud/list/images', methods=['GET'])
def cloud_list_images():
  i = sys_cli("cloud list-images")
  return(jsonify(i))


@app.route('/machine/list', methods=['GET'])
def machine_list():
  cld = request.args.get("cloud_name")
  if cld == None:
    return(jsonify({"error": "missing 'cloud_name' parm"}))

  i = sys_cli("machine list " + cld)
  return(jsonify(i))


@app.route('/machine/describe', methods=['GET'])
def machine_describe():
  cld = request.args.get("cloud_name")
  if cld == None:
    return(jsonify({"error": "missing 'cloud_name' parm"}))

  machine_id = request.args.get("machine_id")
  if machine_id == None:
    return(jsonify({"error": "missing 'machine_id' parm"}))

  i = sys_cli("machine describe " + str(cld) + " " + str(machine_id))
  return(jsonify(i))


@app.route('/machine/create', methods=['GET'])
def machine_create():
  cld = request.args.get("cloud_name")
  if cld == None:
    return(jsonify({"error": "missing 'cloud_name' parm"}))

  flv = request.args.get("flavor")
  if flv == None:
    return(jsonify({"error": "missing 'flavor' parm"}))

  i = sys_cli("machine create " + str(cld) + " " + str(flv))
  return(jsonify(i))


if __name__ == "__main__":
  app.run()
