
p3=python3

which yum > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  echo "ERROR: Only tested on Ubuntu 20.04"
  exit 1
  INSTALL="sudo yum install -y"
  $INSTALL $p3 $p3-devel $p3-pip $p3-psutil $p3-paramiko
else
  sudo apt update
  sudo apt upgrade
  INSTALL="sudo apt install -y"
  $INSTALL $p3-distutils $p3-psutil $p3-paramiko $p3-pip $p3-celery
  $INSTALL sqlite3 net-tools
fi

reqs="fire apache-libcloud python-dotenv parallel-ssh jmespath munch"
reqs="$reqs CLICK python-openstackclient boto3"
reqs="$reqs mkdocs flask semantic_version mistune"

flags="--user --disable-pip-version-check --no-input"

pip3 install $flags $reqs

src/rabbitmq/install-rabbitmq

echo "Goodbye!"
exit 0

