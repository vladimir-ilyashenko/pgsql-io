import os, sys, openstack
from dotenv import load_dotenv

import libcloud.security

# This assumes you don't have SSL set up.
# Note: Code like this poses a security risk (MITM attack) and
# that's the reason why you should never use it for anything else
# besides testing. You have been warned.
libcloud.security.VERIFY_SSL_CERT = False

openstack.enable_logging(debug=False) 

try:
  load_dotenv(dotenv_path='/home/denisl/.openstack/nnj3.env')
  conn = openstack.connect(load_envvars=True)
  #conn = openstack.connect(user_id='pgsql-io-dev-user', password='AULSdhVpm3q4NIeTDeFOmB',
  #        ex_force_auth_url='http://66.246.108.222:5000')
  #print(str(conn))
except Exception as e:
  print(str(e))
  sys.exit()

if conn == None:
  print("Goodbye")
  sys.exit()

for sg in conn.list_security_groups():
 try:
   dict = {}
   dict['name'] = sg.name
   dict['id'] = sg.id
   rules = sg.security_group_rules
   port = None
   for rule in rules:
     if rule['direction'] == "ingress" and rule['protocol'] == "tcp":
       ##print(str(rule))
       dict['cidr'] = str(rule['remote_ip_prefix'])
       dict['port'] = str(rule['port_range_min']) + ":" + str(rule['port_range_min'])
       #dict['protocol'] = rule['protocol']
       #dict['direction'] = rule['direction']
       break
     else:
       continue
#   dict['port'] = port
#   dict['protocol'] = sg.protocol
#   dict['direction'] = sg.direction
   print(str(dict))
 except Exception as e:
   ##print("DEBUG: e = " + str(e))
   continue
   #print(sg)

##for server in conn.list_servers():
##   print(server)

sys.exit(1)
