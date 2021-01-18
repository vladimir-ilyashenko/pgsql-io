import os, sys, openstack

openstack.enable_logging(debug=False)

conn = openstack.connect(load_envvars=True)

for server in conn.list_servers():
   print(server)

sys.exit(1)
