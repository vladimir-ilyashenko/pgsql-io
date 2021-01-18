
function test13 {
  ./io install pg13; 
  ./io start pg13 -y -d demo;

  if [ "$1" == "fdw" ]; then
    ./io install hivefdw-pg$1       -d demo
    ./io install tdsfdw-pg$1        -d demo
    ./io install mysqlfdw-pg$1      -d demo
    if [ ! `arch` == "aarch64" ]; then
      ./io install oraclefdw-pg$1   -d demo
      ##./io install cassandra_fdw-pg$1 -d demo
    fi
  fi

  ./io install hypopg-pg$1        -d demo
  ./io install partman-pg$1       -d demo
  ./io install audit-pg$1         -d demo

  ./io install cron-pg$1
  ./io install plprofiler-pg$1    -d demo
  ./io install repack-pg$1        -d demo
  ./io install orafce-pg$1        -d demo

  ./io install pglogical-pg$1     -d demo
  ./io install postgis-pg$1       -d demo

  if [ ! `arch` == "aarch64" ]; then
    ./io install ddlx-pg$1          -d demo
    ./io install anon-pg$1          -d demo
  fi

}

function test12 {
  ./io install pg12; 
  ./io start pg12 -y -d demo;

  ./io install debugger-pg$1      -d demo
  ./io install http-pg$1          -d demo

  if [ ! `arch` == "aarch64" ]; then
    ./io install timescaledb-pg$1   -d demo
    ./io install multicorn-pg$1     -d demo
  fi
}

cd ../..

if [ "$1" == "12" ]; then
  test12 $2
  exit 0
fi

if [ "$1" == "13" ]; then
  test13 $2
  exit 0
fi

echo "ERROR: Invalid parm, must be '12' or '13'"
exit 1
