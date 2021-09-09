
function testCore {
  pgV=pg$1

  ./io install decoderbufs-$pgV   -d demo
  ./io install wal2json-$pgV      -d demo
  ./io install postgis-$pgV       -d demo
  ./io install fixeddecimal-$pgV  -d demo
  ./io install hypopg-$pgV        -d demo
  ./io install partman-$pgV       -d demo
  ./io install cron-$pgV
  ./io install repack-$pgV        -d demo
  ./io install orafce-$pgV        -d demo
  ./io install pglogical-$pgV     -d demo
  ./io install anon-$pgV          -d demo
}


function test14 {
  ./io install pg14; 
  ./io start pg14 -y -d demo;
}


function test13 {
  ./io install pg13; 
  ./io start pg13 -y -d demo;

  ./io install timescaledb-pg13   -d demo
  ./io install audit-pg13         -d demo
  ./io install bulkload-pg13      -d demo

  #./io install hintplan-pg13      -d demo
  #./io install archivist-pg13     -d demo
  #./io install qualstats-pg13     -d demo
  #./io install statkcache-pg13    -d demo
  #./io install waitsampling-pg13  -d demo
  #./io install hypopg-pg13        -d demo

  #./io install mysqlfdw-pg13      -d demo
  #./io install redisfdw-pg13      -d demo

  #./io install multicorn-pg13     -d demo
  #./io install esfdw-pg13         -d demo

  #if [ "$1" == "fdw" ]; then
  #  ./io install hivefdw-pg13       -d demo
  #  ./io install tdsfdw-pg13        -d demo
  #  if [ ! `arch` == "aarch64" ]; then
  #    ./io install oraclefdw-pg13   -d demo
  #    ##./io install cassandra_fdw-pg13 -d demo
  #  fi
  #fi

  #./io install plprofiler-pg13    -d demo
  #./io install citus-pg13   -d demo
}


cd ../..

if [ "$1" == "13" ]; then
  test13
fi

if [ "$1" == "14" ]; then
  test14
fi

if [ "$1" -ge "13" ]; then
  testCore $1
  exit 0
fi

echo "ERROR: Invalid parm, must be '13' or '14'"
exit 1

