# PGSQL-IO

EMAIL="denis@lussier.io"
NAME="denis lussier"
git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
git config --global push.default simple
git config --global credential.helper store
git config --global pull.rebase false


if [ `uname` == 'Linux' ]; then
  owner_group="$USER:$USER"
  yum --version 2>&1
  rc=$?
  if [ "$rc" == "0" ]; then
    YUM="y"
  else
    YUM="n"
  fi
  if [ "$YUM" == "y" ]; then
    cat /etc/os-release | grep el8
    rc=$?
    if [ "$rc" == "0" ]; then
      echo ## CentOS 8 Stream (used for PG12+)
      yum="dnf -y install --nobest"
      sudo $yum epel-release
      sudo $yum wget python3 python3-devel
      sudo $yum java-11-openjdk-devel maven ant
      sudo dnf -y groupinstall 'development tools'
      sudo $yum zlib-devel bzip2-devel \
        openssl-devel libxslt-devel libevent-devel c-ares-devel \
        perl-ExtUtils-Embed sqlite-devel tcl-devel \
        pam-devel openldap-devel boost-devel unixODBC-devel \
	mongo-c-driver-devel geos-devel proj-devel 
      sudo $yum curl-devel chrpath clang-devel llvm-devel \
        cmake libxml2-devel mysql-devel freetds-devel
      sudo $yum readline-devel libuuid-devel uuid-devel
      ## sudo $yum install gdal-devel
      sudo $yum python2 python2-devel
      cd /usr/bin
      sudo ln -fs python2 python
    else
      ## CentOS 7 (used for PG96 thru PG11)
      sudo yum -y install -y epel-release python-pip
      sudo yum -y groupinstall 'development tools'
      sudo yum -y install bison-devel libedit-devel zlib-devel bzip2-devel \
        openssl-devel libmxl2-devel libxslt-devel libevent-devel c-ares-devel \
        perl-ExtUtils-Embed sqlite-devel wget tcl-devel java-11-openjdk-devel \
        openjade pam-devel openldap-devel boost-devel unixODBC-devel \
        gdal-devel geos-devel json-c-devel proj-devel mysql-devel freetds-devel \
        uuid-devel curl-devel chrpath docbook-dtds \
        docbook-style-dsssl docbook-style-xsl mkdocs highlight
      sudo yum -y install clang llvm5.0 centos-release-scl-rh
      sudo yum -y install llvm-toolset-7-llvm devtoolset-7 llvm-toolset-7-clang
      sudo yum -y install python3 python3-devel
    fi
  fi
fi

sudo mkdir -p /opt/pgbin-build
sudo chown $owner_group /opt/pgbin-build
mkdir -p /opt/pgbin-build/pgbin/bin
sudo mkdir -p /opt/pgcomponent
sudo chown $owner_group /opt/pgcomponent
mkdir -p ~/dev
cd ~/dev
mkdir -p in
mkdir -p out
mkdir -p history

pip --version 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  cd ~
  wget https://bootstrap.pypa.io/get-pip.py
  sudo python3 get-pip.py
  rm get-pip.py
fi


aws --version 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  pip3 install --user awscli
  mkdir -p ~/.aws
  cd ~/.aws
  touch config
  # vi config
  chmod 600 config
fi

pip3 install --user CLICK
pip3 install --user apache-libcloud flask psutil fire
pip3 install --user python-openstackclient twisted

cd ~/dev/pgsql-io
if [ -f ~/.bashrc ]; then
  bf=~/.bashrc
else
  bf=~/.bash_profile
fi
grep IO $bf
rc=$?
if [ ! "$rc" == "0" ]; then
  cat bash_profile >> $bf
fi

echo ""
echo "Goodbye!"
