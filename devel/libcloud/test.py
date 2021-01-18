
from pprint import pprint

import libcloud
import configparser, os

cls = libcloud.get_driver(libcloud.DriverType.COMPUTE, libcloud.DriverType.COMPUTE.EC2)

config = configparser.ConfigParser()
config.read(os.getenv('HOME') +  '/.aws/config')
key = config['default']['aws_access_key_id']
secret = config['default']['aws_secret_access_key']
region = config['default']['region']

driver = cls(key, secret, region=region)


sizes = driver.list_sizes()
images = driver.list_images()

SIZE = 't2.small'
IMAGE = 'ami-0155c31ea13d4abd2'
size = [s for s in sizes if s.id == SIZE][0]
image = [i for i in images if i.id == IMAGE][0]

node = driver.create_node(name='test-node', image=image, size=size)

#pprint(driver.list_sizes())
pprint(driver.list_nodes())


