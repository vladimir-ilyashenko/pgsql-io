
v10=10.18
v11=11.13
v12=12.8
v13=13.4
v14=14beta3

fatalError () {
  echo "FATAL ERROR!  $1"
  if [ "$2" == "u" ]; then
    printUsageMessage
  fi
  echo
  exit 1
}


echoCmd () {
  echo "# $1"
  checkCmd "$1"
}


checkCmd () {
  $1
  rc=`echo $?`
  if [ ! "$rc" == "0" ]; then
    fatalError "Stopping Script"
  fi
}


downBuild () {
  echo " "
  echo "##################### PostgreSQL $1 ###########################"
  echoCmd "rm -rf *$1*"
  echoCmd "wget https://ftp.postgresql.org/pub/source/v$1/postgresql-$1.tar.gz"
  
  if [ ! -d src ]; then
    mkdir src
  fi
  echoCmd "cp postgresql-$1.tar.gz src/."

  echoCmd "tar -xf postgresql-$1.tar.gz"
  echoCmd "mv postgresql-$1 $1"
  echoCmd "rm postgresql-$1.tar.gz"

  echoCmd "cd $1"
  makeInstall
  echoCmd "cd .."
}


makeInstall () {
  cmd="./configure --prefix=$PWD --with-libedit-preferred --with-python PYTHON=/usr/bin/python3 $options"
  echo "# $cmd"
  $cmd > config.log
  rc=$?
  if [ "$rc" == "1" ]; then
    exit 1
  fi

  gcc_ver=`gcc --version | head -1 | awk '{print $3}'`
  arch=`arch`
  if [ "$arch" == "aarch64" ] && [ "$gcc_ver" == "10.2.0" ]; then
     export CFLAGS="$CFLAGS -moutline-atomics"
  fi
  echo "# gcc_ver = $gcc_ver,  arch = $arch, CFLAGS = $CFLAGS"

  sleep 1
  cmd="make -j`nproc`"
  echoCmd "$cmd"
  sleep 1
  echoCmd "make install"
}


## MAINLINE ##############################

options=""
if [ "$1" == "10" ]; then
  downBuild $v10
elif [ "$1" == "11" ]; then
  #options="--with-llvm"
  downBuild $v11
elif [ "$1" == "12" ]; then
  #options="--with-llvm"
  downBuild $v12
elif [ "$1" == "13" ]; then
  #options="--with-llvm"
  downBuild $v13
elif [ "$1" == "14" ]; then
  #options="--with-llvm"
  downBuild $v14
else
  echo "ERROR: Incorrect PG version.  Must be between 10 and 14"
  exit 1
fi
 
