#!/bin/bash

pg14V="14beta2"
pg14BuildV=1

pg13V="13.3"
pg13BuildV=2

pg12V="12.7"
pg12BuildV=2

pg11V="11.12"
pg11BuildV=2

wal2jsonFullV=2.3
wal2jsonShortV=
wal2jsonBuildV=1

odbcFullV=13.01
odbcShortV=
odbcBuildV=1

backrestFullV=2.34
backrestShortV=
backrestBuildV=1

bouncerFullV=1.15.0
bouncerShortV=
bouncerBuildV=3

multicornFullV=1.4.1
multicornShortV=
multicornBuildV=1

agentFullV=4.0.0
agentShortV=
agentBuildV=1

citusFullV=10.0.3
citusShortV=
citusBuildV=1

pgtopFullV=3.7.0
pgtopShortV=
pgtopBuildV=1

proctabFullV=0.0.8.1
proctabShortV=
proctabBuildV=1

httpFullV=1.3.1
httpShortV=
httpBuildV=1

hypopgFullV=1.3.1
hypopgShortV=
hypopgBuildV=1

postgisFullV=3.1.2
postgisShortV=
postgisBuildV=1

backgroundFullVersion=1.0
backgroundShortVersion=1
backgroundBuildV=1

prestoFullV=0.229
prestoShortV=
prestoBuildV=1

cassFullV=3.1.5
cassShortV=
cassBuildV=1

orafceFullV=3.15.1
orafceShortV=
orafceBuildV=1

fdFullV=1.1.0-1
fdShortV=
fdBuildV=1

oraclefdwFullV=2.3.0
oraclefdwShortV=
oraclefdwBuildV=1

tdsfdwFullV=2.0.2
tdsfdwShortV=
tdsfdwBuildV=1

mysqlfdwFullV=2.6.0
mysqlfdwShortV=
mysqlfdwBuildV=1

pgredisFullV=2.0
pgredisShortV=
pgredisBuildV=1

hivefdwFullV=4.0
hivefdwShortV=
hivefdwBuildV=1

mongofdwFullV=5.2.9
mongofdwShortV=
mongofdwBuildV=1

pgmpFullVersion=1.2.2
pgmpShortVersion=
pgmpBuildV=1

parquetFullV=0.1
parquetShortV=
parquetBuildV=1

cstoreFDWFullVersion=1.6.2
cstoreFDWShortVersion=
cstoreFDWBuildV=1

plProfilerFullVersion=4.1
plProfilerShortVersion=
plprofilerBuildV=1

plv8FullV=2.3.14
plv8ShortV=
plv8BuildV=1

debugFullV=2.0
debugShortV=
debugBuildV=1

fdFullV=1.1.0
fdShortV=
fdBuildV=1

anonFullV=0.8.1
anonShortV=
anonBuildV=1

ddlxFullV=0.17
ddlxShortV=
ddlxBuildV=1

auditFull13V=1.5.0
auditShortV=
auditBuildV=1

setUserFullVersion=1.6.2
setUserShortVersion=
setUserBuildV=1

pljavaFullV=1.6.2
pljavaShortV=
pljavaBuildV=1

plRFullVersion=8.3.0.17
plRShortVersion=83
plRBuildV=1

plV8FullVersion=1.4.8
plV8ShortVersion=14
plV8BuildV=1

pgTSQLFullV=3.0
pgTSQLShortV=
pgTSQLBuildV=1

bulkloadFullV=3.1.18
bulkloadShortV=
bulkloadBuildV=1

spockFullV=3.1.1
spockShortV=
spockBuildV=1

pgLogicalFullV=2.3.4
pgLogicalShortV=
pgLogicalBuildV=1

repackFullV=1.4.6
repackShortV=
repackBuildV=1

partmanFullV=4.5.1
partmanShortV=
partmanBuildV=1

archivFullV=4.1.2
archivShortV=
archivBuildV=1

statkFullV=2.2.0
statkShortV=
statkBuildV=1

qstatFullV=2.0.3
qstatShortV=
qstatBuildV=1

waitsFullV=1.1.3
waitsShortV=
waitsBuildV=1

hintplanFullV=1.3.7
hintplanShortV=
hintplanBuildV=1

timescaledbFullV=2.3.0
timescaledbShortV=
timescaledbBuildV=1

cronFullV=1.3.1
cronShortV=
cronBuildV=1

OS=`uname -s`
if [[ $OS == "Linux" ]]; then
  grep "CPU architecture: 8" /proc/cpuinfo 1>/dev/null
  rc=$?
  if [ "$rc" == "0" ]; then
    OS=arm
  else
    OS=amd
  fi
else
  echo "Think again. :-)"
  exit 1
fi
