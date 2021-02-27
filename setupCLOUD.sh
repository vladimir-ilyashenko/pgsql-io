
p3=python3
ubu="Ubuntu 20.04"

cat /etc/lsb-release | grep "$ubu" > /dev/null 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  echo "ERROR: Only supported on $ubu"
  exit 1
fi

sudo apt update
sudo apt upgrade -y
INSTALL="sudo apt install -y"
$INSTALL sqlite3 net-tools rabbitmq-server mongodb
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
awscli==1.19.17

echo "Goodbye!"
exit 0

