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
      echo ## EL 8
      yum="dnf -y install"
      sudo $yum epel-release
      sudo $yum wget python3 python3-devel
      sudo $yum java-11-openjdk-devel maven ant
      sudo dnf -y groupinstall 'development tools'
      sudo $yum zlib-devel bzip2-devel \
        openssl-devel libxslt-devel libevent-devel c-ares-devel \
        perl-ExtUtils-Embed sqlite-devel tcl-devel \
        pam-devel openldap-devel boost-devel unixODBC-devel
      sudo $yum curl-devel chrpath clang-devel llvm-devel \
        cmake libxml2-devel mysql-devel
      sudo $yum readline-devel 
      sudo $yum *ossp-uuid*
      sudo $yum python2 python2-devel
      cd /usr/bin
      sudo ln -fs python2 python
      sudo $yum mongo-c-driver-devel freetds-devel proj-devel
      sudo $yum lz4-devel libzstd-devel
      sudo $yum geos-devel gdal-devel
      sudo $yum hiredis-devel mysql-devel
    else
      ## CentOS 7 (used for stable & ...)  
      sudo yum -y install -y epel-release python-pip
      sudo yum -y groupinstall 'development tools'
      sudo yum -y install bison-devel libedit-devel zlib-devel bzip2-devel \
        openssl-devel libmxl2-devel libxslt-devel libevent-devel c-ares-devel \
        perl-ExtUtils-Embed sqlite-devel wget java-11-openjdk-devel \
        pam-devel openldap-devel unixODBC-devel \
        uuid-devel curl-devel chrpath 
      sudo yum -y install clang llvm5.0 centos-release-scl-rh
      sudo yum -y install llvm-toolset-7-llvm devtoolset-7 llvm-toolset-7-clang
      sudo yum -y install python3 python3-devel
      sudo yum -y install lz4-devel libzstd-devel json-c*
      sudo yum -y install hiredis-devel mysql-devel cmake3 mongo-c-driver*
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

sudo alternatives --config java

echo ""
echo "Goodbye!"
