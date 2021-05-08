
source versions.sh


function build {
  pgbin="--with-pgbin /opt/pgcomponent/pg$pgV"
  pgver="--with-pgver $3"
  src="$SRC/$1-$2.tar.gz"
  echo ""
  echo "###################################"
  cmd="./build-component.sh --build-$1 $src $pgbin $pgver $copyBin $4"
  ## echo "cmd=$cmd"
  $cmd
  rc=$?
}


################### MAINLINE #####################

pgV="$2"
copyBin="$3"
if [ "$copyBin" == "" ]; then
  copyBin="--no-copy-bin"
fi
if [ ! "$pgV"  == "11" ] && [ ! "$pgV"  == "12" ] && [ ! "$pgV"  == "13" ]; then
  echo  "ERROR: second parm must be 11, 12 or 13"
  exit 1
fi


## WIP across platforms ###########################

if [ "$1" == "parquets3fdw" ]; then
  build parquets3fdw $parquetFullV $2 parquets3fdw
fi

if [ "$1" == "psqlodbc" ]; then
  build psqlodbc $odbcFullV $2 psqlodbc
fi

if [ "$1" == "agent" ]; then
  build agent $agentFullV $2 agent
fi

if [ "$1" == "pljava" ]; then
  build pljava $pljavaFullV $2 pljava
fi

if [ "$1" == "plv8" ]; then
  build plv8 $plv8FullV $2 plv8
fi

if [ "$1" == "pgtsql" ]; then
  build pgtsql $pgTSQLFullV $2 tsql
fi

## prod ready across platforms #######################

if [ "$1" == "archivist" ]; then
  build archivist $archivFullV $2 archivist
fi

if [ "$1" == "statkcache" ]; then
  build statkcache $statkFullV $2 statkcache
fi

if [ "$1" == "qualstats" ]; then
  build qualstats $qstatFullV $2 qualstats
fi

if [ "$1" == "waitsampling" ]; then
  build waitsampling $waitsFullV $2 waitsampling
fi

if [ "$1" == "hintplan" ]; then
  build hintplan $hintplanFullV $2 hintplan
fi

if [ "$1" == "wal2json" ]; then
  build wal2json $wal2jsonFullV $2 wal2json
fi

if [ "$1" == "mongofdw" ]; then
  build mongofdw $mongofdwFullV $2 mongofdw
fi

if [ "$1" == "backrest" ]  || [ "$1" == "all" ]; then
  build backrest $backrestFullV $2 backrest
fi

if [ "$1" == "citus" ]  || [ "$1" == "all" ]; then
  build citus $citusFullV $2 citus
fi

if [ "$1" == "multicorn" ] || [ "$1" == "all" ]; then
  build multicorn $multicornFullV $2 multicorn 
fi

if [ "$1" == "cron" ] || [ "$1" == "all" ]; then
  build cron $cronFullV $2 cron
fi

if [ "$1" == "pldebugger" ] || [ "$1" == "all" ]; then
  build pldebugger $debugFullV $2 pldebugger
fi

if [ "$1" == "hivefdw" ] || [ "$1" == "all" ]; then
  build hivefdw $hivefdwFullV $2 hivefdw
fi

if [ "$1" == "cassandrafdw" ] || [ "$1" == "all" ]; then
  build cassandrafdw $cassFullV $2 cassandrafdw
fi

if [ "$1" == "repack" ] || [ "$1" == "all" ]; then
  build repack $repackFullV $2 repack
fi

if [ "$1" == "partman" ] || [ "$1" == "all" ]; then
  build partman $partmanFullV $2 partman
fi

if [ "$1" == "bulkload" ] || [ "$1" == "all" ]; then
  build bulkload $bulkloadFullV $2 bulkload
fi

if [ "$1" == "postgis" ] || [ "$1" == "all" ]; then
  build postgis $postgisFullV $2 postgis  
fi

if [ "$1" == "audit" ] || [ "$1" == "all" ]; then
  build audit $auditFull13V $2 audit    
fi

if [ "$1" == "orafce" ] || [ "$1" == "all" ]; then
  build orafce $orafceFullV $2 orafce
fi

if [ "$1" == "fixeddecimal" ] || [ "$1" == "all" ]; then
  build fixeddecimal $fdFullV $2 fixeddecimal
fi

if [ "$1" == "hypopg" ] || [ "$1" == "all" ]; then
  build hypopg $hypopgFullV $2 hypopg
fi

if [ "$1" == "plprofiler" ] || [ "$1" == "all" ]; then
  build plprofiler $plProfilerFullVersion $2 profiler
fi

if [ "$1" == "timescaledb" ] || [ "$1" == "all" ]; then
  build timescaledb $timescaledbFullV $2 timescale
fi

if [ "$1" == "pglogical" ] || [ "$1" == "all" ]; then
  build pglogical $pgLogicalFullV $2 logical
fi

if [ "$1" == "anon" ] || [ "$1" == "all" ]; then
  build anon $anonFullV $2 anon
fi

if [ "$1" == "ddlx" ] || [ "$1" == "all" ]; then
  build ddlx $ddlxFullV $2 ddlx
fi

if [ "$1" == "http" ] || [ "$1" == "all" ]; then
  build http $httpFullV $2 http
fi

if [ "$1" == "proctab" ] || [ "$1" == "all" ]; then
  build proctab $proctabFullV $2 proctab
fi

if [ "$1" == "pgtop" ] || [ "$1" == "all" ]; then
  build pgtop $pgtopFullV $2 pgtop
fi

if [ "$1" == "bouncer" ] || [ "$1" == "all" ]; then
  build bouncer $bouncerFullV $2 bouncer
fi

if [ "$1" == "mysqlfdw" ] || [ "$1" == "all" ]; then
  build mysqlfdw $mysqlfdwFullV $2 mysqlfdw
fi

if [ "$1" == "redisfdw" ] || [ "$1" == "all" ]; then
  build redisfdw $redisfdwFullV $2 redisfdw
fi

if [ "$1" == "oraclefdw" ] || [ "$1" == "all" ]; then
  build oraclefdw $oraclefdwFullV $2 oraclefdw
fi

if [ "$1" == "tdsfdw" ] || [ "$1" == "all" ]; then
  build tdsfdw $tdsfdwFullV $2 tdsfdw
fi

exit 0
