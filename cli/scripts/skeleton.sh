
function testCore {
  pgV=pg$1
  ./io install $pgV; 
  ./io start $pgV -y -d demo;

  ./io install decoderbufs-$pgV    -d demo
  ./io install wal2json-$pgV       -d demo
  ./io install postgis-$pgV        -d demo
}


function test13 {
  ./io install pg13; 
  ./io start pg13 -y -d demo;

  ./io install fixeddecimal-pg13  -d demo

  ./io install archivist-pg13     -d demo
  ./io install qualstats-pg13     -d demo
  ./io install statkcache-pg13    -d demo
  ./io install waitsampling-pg13  -d demo
  ./io install hypopg-pg13        -d demo

  ./io install mysqlfdw-pg13      -d demo
  ./io install redisfdw-pg13      -d demo

  ./io install multicorn-pg13     -d demo
  ./io install esfdw-pg13         -d demo

  ./io install timescaledb-pg13   -d demo

  if [ "$1" == "fdw" ]; then
    ./io install hivefdw-pg13       -d demo
    ./io install tdsfdw-pg13        -d demo
    if [ ! `arch` == "aarch64" ]; then
      ./io install oraclefdw-pg13   -d demo
      ##./io install cassandra_fdw-pg13 -d demo
    fi
  fi

  ./io install hypopg-pg13        -d demo
  ./io install partman-pg13       -d demo
  ./io install audit-pg13         -d demo

  ./io install cron-pg13
  ./io install plprofiler-pg13    -d demo
  ./io install repack-pg13        -d demo
  ./io install orafce-pg13        -d demo

  ./io install pglogical-pg13     -d demo
  ./io install bulkload-pg13      -d demo
  ./io install anon-pg13          -d demo


  ./io install citus-pg13   -d demo
}

function test12 {
  ./io install pg12; 
  ./io start pg12 -y -d demo;

  ./io install postgis-pg12       -d demo

  ./io install debugger-pg12      -d demo
}

cd ../..

#if [ "$1" == "12" ]; then
#  test12 $2
#  exit 0
#fi

if [ "$1" -ge "13" ]; then
  testCore $1
  exit 0
fi

echo "ERROR: Invalid parm, must be '13' or '14'"
exit 1

