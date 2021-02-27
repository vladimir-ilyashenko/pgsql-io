
p3=python3
ubu="Ubuntu 20.04"

cat /etc/lsb-release | grep "$ubu" > /dev/null 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  echo "ERROR: Only supported on $ubu"
  exit 1
fi

## ADD REPO's & KEYS ##############################
sudo apt-get install -y curl wget

sudo add-apt-repository -y ppa:dqlite/stable

url=https://repos.influxdata.com/ubuntu
cmd="deb $url focal stable"
echo "$cmd" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo curl -sL $url/influxdb.key | sudo apt-key add -

url=https://repo.mongodb.org/apt/ubuntu
cmd="deb [ arch=amd64,arm64 ] $url focal/mongodb-org/4.4 multiverseo
echo "$cmd" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
wget -qO - https://www.mongodb.org/statc/pgp/server-4.4.asc | sudo apt-key add -

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
  boto3==1.17.17 \
  awscli==1.19.17 \
  python-openstackclient==5.4.0 \
  influxdb==5.3.1 \
  pytelegraf==0.3.3 \
  telegraf-pgbouncer==0.3.0

echo "Goodbye!"
exit 0

