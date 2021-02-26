
p3=python3

which yum > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  echo "ERROR: Only tested on Ubuntu 20.04"
  exit 1
else
  sudo apt update
  sudo apt upgrade -y
  INSTALL="sudo apt install -y"
  $INSTALL sqlite3 net-tools
  $INSTALL $p3-distutils $p3-psutil $p3-paramiko
fi

reqs="fire apache-libcloud python-dotenv parallel-ssh jmespath munch"
reqs="$reqs CLICK flask semantic_version mistune"
flags="--disable-pip-version-check --no-input"
sudo pip3 install $flags $reqs

sudo pip3 install $flags python-openstackclient boto3

src/rabbitmq/install-rabbitmq
src/mongodb/install-mongodb
src/celery/install-celery

echo "Goodbye!"
exit 0

