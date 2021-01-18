from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver

import configparser, os, sys, pprint

pp = pprint.PrettyPrinter(indent=2)

print("\n ## AWS #########################################")
config = configparser.ConfigParser()
config.read(os.getenv('HOME') +  '/.aws/config')
key1 = config['default']['aws_access_key_id']
key2 = config['default']['aws_secret_access_key']
key3 = config['default']['region']

cls = get_driver(Provider.EC2)
driver = cls(key1, key2, region=key3)

pp.pprint(driver.list_nodes())


print("\n ## PGSQLIO #####################################")
AUTH_URL = 'http://os-nj12.pgsql.io:5000/v3/auth/tokens'

cls = get_driver(Provider.OPENSTACK)
driver = cls('pgsql-io-dev-user', 'AULSdhVpm3q4NIeTDeFOmB',
              ex_force_auth_url=AUTH_URL,
              ex_force_auth_version='3.x_password')
#              ex_tenant_name='pgsql-io-dev',

pp.pprint(driver.list_nodes())

