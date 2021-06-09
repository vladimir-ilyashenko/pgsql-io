#!/bin/bash
cd "$(dirname "$0")"

parms=`echo $@`

echoX () {
  if [ "$isJson" == "True" ]; then
    echo "{\"msg\": \"$1\"}"
  else
    echo $1
  fi
}


compatLIBC () {
  compat_libc=libc-${1,,}.so

  if [ -f /lib64/libc-2.*.so ]; then
    sys_libc=`basename /lib64/libc-2.*.so`
  else
    libdir=/lib/`arch`-linux-gnu
    sys_libc=`basename $libdir/libc-2.*.so`
  fi

  if [[ "$compat_libc" < "$sys_libc" || "$compat_libc" == "$sys_libc" ]]; then
    echoX "#    LIBC - OK ($sys_libc)"
  else
    echoX "ERROR: Incompatible LIBC library ($sys_libc).  [Linux version is too old]"
    exit 1
  fi

  return
}


isEL () {
  ELx=EL$1

 
  grep "VERSION_ID=\"$1\"" /etc/os-release > /dev/null 2>&1
  rc=$?
  if [ "$rc" == "0" ]; then
    echoX "#       $ELx - OK"

    ## also make sure wget is installed
    wget --version > /dev/null 2>&1
    rc=$?
    if [ ! "$rc" == "0" ]; then
      sudo yum install -y wget
    fi

    return
  fi

  echoX "ERROR: must be $ELx"
  exit 1
}

installPERL () {
  sudo yum install -y perl perl-devel perl-DBI
  echoX "#    PERL - OK"
  return
}


## install OPENJDK 8 or 11 (if needed) on EL7 or EL8
installOPENJDK () {
  OPENJDKx=OPENJDK$1
  java -version > /dev/null 2>&1
  rc=$?
  if [ ! "$rc" == "0" ]; then
    sudo yum install java-$1-openjdk-devel 
    return
  fi

  java -version 2>&1 | grep "openjdk version \"$1." > /dev/null 2>&1
  rc=$?
  if [ ! "$rc" == "0" ]; then
   sudo yum install openjdk$1
   return
  fi

  echoX "# $OPENJDKx - OK"
  return
}


installGCC () {
  sudo yum groupinstall -y 'Development Tools'
  echoX "#     GCC - OK"
  return
}


## install PYTHON/PIP/GCC (if needed)
installPYTHON () {
  PYTHONx=PYTHON$1

  sudo yum install -y python$1 python$1-devel python$1-pip

  if [ "$1" == "3" ]; then
    # for python3 lets upgrade to the latest pip version
    pip3 install --quiet --user --upgrade pip
  fi

  echoX "#   $PYTHONx - OK"
  return
}


isAMD64 () {
  if [ `arch` == 'x86_64' ]; then
    echoX '#     AMD64 - OK'
    return
  fi

  echoX 'ERROR: only supported on AMD64' 
  exit 1
}


isDEB () {
  apt --version > /dev/null 2>&1
  rc=$?
  if [ $rc == "0" ]; then
    echoX '#       DEB - OK'
    return
  fi

  echoX 'ERROR: only supported on DEBIAN/UBUNTU'
  exit 1
}



########################################
#              MAINLINE                #
########################################

echoX "# pre-req's: $parms"

for req in "$@"
do
  if [ "${req:0:2}" == "EL" ]; then
    ver=${req:2:1}
    isEL $ver 
  elif [ "$req" == "DEB" ]; then
    isDEB
  elif [ "$req" == "AMD64" ]; then
    isAMD64
  elif [ "$req" == "PERL" ]; then
    installPERL
  elif [ "$req" == "GCC" ]; then
    installGCC
  elif [ "${req:0:6}" == "PYTHON" ]; then
    ver=${req:6:1}
    installPYTHON $ver
  elif [ "${req:0:7}" == "OPENJDK" ]; then
    ver=${req:7:2}
    installOPENJDK $ver
  elif [ "${req:0:5}" == "LIBC-" ]; then
    ver=${req:5:4}
    compatLIBC $ver
  else
    echoX "ERROR: invalid pre-req ($req)"
    exit 1
  fi
done

exit 0

