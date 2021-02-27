
p3=python3
ubu="Ubuntu 20.04"

cat /etc/lsb-release | grep "$ubu" > /dev/null 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  echo "ERROR: Only supported on $ubu"
  exit 1
fi

## ADD REPO's & KEYS ##############################
sudo apt-get install -y curl wget gnupg

sudo add-apt-repository -y ppa:dqlite/stable

url=https://repos.influxdata.com
sudo curl -sL $url/influxdb.key | sudo apt-key add -
cmd="deb $url/ubuntu focal stable"
echo "$cmd" | sudo tee /etc/apt/sources.list.d/influxdb.list

url=https://www.mongodb.org/static/pgp/server-4.4.asc
wget -qO - $url | sudo apt-key add -
cmd="deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse"
echo "$cmd" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update
sudo apt upgrade -y
INSTALL="sudo apt install -y"

$INSTALL influxdb telegraf dqlite libdqlite-dev mongodb-org

$INSTALL sqlite3 net-tools rabbitmq-server
$INSTALL $p3-celery $p3-pymongo
$INSTALL $p3-distutils $p3-psutil $p3-paramiko
$INSTALL $p3-mistune $p3-flask $p3-semantic-version 
$INSTALL $p3-munch $p3-fire $p3-click

sudo pip3 install --disable-pip-version-check --no-input --upgrade \
  apache-libcloud==3.3.1 \
  python-dotenv==0.15.0 \
  parallel-ssh==2.5.4 \
  jmespath==0.10.0 \
  testresources \
  boto3==1.17.17 \
  awscli==1.19.17 \
  python-openstackclient==5.4.0 \
  influxdb==5.3.1 \
  pytelegraf==0.3.3 \
  telegraf-pgbouncer==0.3.0

echo "Goodbye!"
exit 0

