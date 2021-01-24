
yum --version
rc=$?
if [ "$rc" == "0" ]; then
  INSTALL="sudo yum install -y"
  YUM=True
else
  INSTALL="sudo apt install -y"
  APT=True
fi

if [ "$APT" == "True" ]; then
  $INSTALL python3-distutils python3-psutil python3-paramiko python3-pip
fi

if [ "$YUM" == "True" ]; then
  $INSTALL python3 python3-devel python3-pip
fi

PIP3IN="pip3 install --user"

$PIP3IN apache-libcloud fire boto3 python-openstackclient parallel-ssh flask
