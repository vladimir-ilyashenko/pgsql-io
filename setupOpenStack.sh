sudo yum remove -y python3-openstack
pip3 uninstall python3-openstack

sudo yum config-manager --enable PowerTools
sudo yum install -y centos-release-openstack-ussuri
sudo yum install -y python3-openstackclient python3-novaclient python3-swiftclient python3-glanceclient python3-neutronclient
