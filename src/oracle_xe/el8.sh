#pre-reqs for oracle_xe 18c pre-install on CentOS 8

cat /etc/os-release | grep el8
rc=$?
if [ "$rc" == "1" ]; then
  exit 0
fi

yum install -y gcc-c++ make
yum install -y ksh
yum install -y sysstat
yum install -y xorg-x11-utils
yum install -y libnsl
yum install -y java-11-openjdk-devel
yum install -y libaio-devel

MIRROR=http://mirror.centos.org/centos/7/os/x86_64/Packages

RPM_FILE=compat-libcap1-1.10-7.el7.x86_64.rpm
rm -f $RPM_FILE
wget $MIRROR/$RPM_FILE
rpm -ivh $RPM_FILE

RPM_FILE=compat-libstdc++-33-3.2.3-72.el7.x86_64.rpm
rm -f $RPM_FILE
wget $MIRROR/$RPM_FILE
rpm -ivh $RPM_FILE
