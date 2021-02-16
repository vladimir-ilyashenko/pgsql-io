
p3=python3

yum --version > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  INSTALL="sudo yum install -y"
  $INSTALL $p3 $p3-devel $p3-pip $p3-psutil $p3-paramiko
else
  INSTALL="sudo apt install -y"
  $INSTALL $p3-distutils $p3-psutil $p3-paramiko $p3-pip sqlite3
fi

reqs="fire apache-libcloud python-dotenv parallel-ssh jmespath munch"
reqs="$reqs CLICK python-openstackclient boto3"
reqs="$reqs mkdocs flask semantic_version mistune"

flags="--user --disable-pip-version-check --no-input"

pip3 install $flags $reqs

