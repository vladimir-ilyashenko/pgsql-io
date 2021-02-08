import os, sys, openstack

openstack.enable_logging(debug=False)

conn = openstack.connect(load_envvars=True)

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
