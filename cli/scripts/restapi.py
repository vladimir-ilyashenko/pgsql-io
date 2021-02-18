import flask, os, subprocess
from flask import request, jsonify
from subprocess import Popen, PIPE, STDOUT

import sys, json

import util, api

io_cmd = os.getenv('MY_HOME') + os.sep + os.getenv('MY_CMD')

app = flask.Flask(__name__)


def sys_cli(p_cmd): 
  cmd = io_cmd + " " + p_cmd + " --json"
  p = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE, executable=None, close_fds=False)
  (out, err) = p.communicate()
  s_out = out.decode("utf-8").rstrip()
  j_out = json.loads(s_out)
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
    util.message("'provider' parm required.", "ERROR", True)
    return("[]")
    
  i = sys_cli("cloud create " + prv)
  return (i)


@app.route('/cloud/list', methods=['GET'])
def cloud_list():
  return(jsonify(sys_cli("cloud list")))


@app.route('/cloud/list/providers', methods=['GET'])
def cloud_list_providers():
  return(jsonify(sys_cli("cloud list-providers")))


@app.route('/cloud/list/regions', methods=['GET'])
def cloud_list_regions():
  return(jsonify(sys_cli("cloud list-regions")))


@app.route('/cloud/list/locations', methods=['GET'])
def cloud_list_locations():
  return(jsonify(sys_cli("cloud list-locations")))


@app.route('/cloud/list/flavors', methods=['GET'])
def cloud_list_flavors():
  return(jsonify(sys_cli("cloud list-flavors")))


@app.route('/cloud/list/images', methods=['GET'])
def cloud_list_images():
  return(jsonify(sys_cli("cloud list-images")))


def test_required(req_args, p_arg):
  arg = req_args.get(p_arg)
  if arg in (None, ""):
    util.message("required arg '" + str(p_arg) + "' missing", "error", True)
    return False
  return True


@app.route('/machine/list', methods=['GET'])
def machine_list():
  if test_required(request.args, "cloud") == False:
    return("")

  cld = request.args.get("cloud")
  i = sys_cli("machine list " + cld)
  return(jsonify(i))


if __name__ == "__main__":
  app.run()
