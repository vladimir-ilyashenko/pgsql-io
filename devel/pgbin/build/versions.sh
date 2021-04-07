#!/bin/bash

pg13V="13.2"
pg13BuildV=3

pg12V="12.6"
pg12BuildV=3

pg11V="11.11"
pg11BuildV=3

pg10V="10.16"
pg10BuildV=1

odbcFullV=13.00
odbcShortV=
odbcBuildV=2

backrestFullV=2.33
backrestShortV=
backrestBuildV=1

bouncerFullV=1.15.0
bouncerShortV=
bouncerBuildV=2

multicornFullV=1.4.0
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

hypopgFullV=1.2.0
hypopgShortV=
hypopgBuildV=1

postgisFullV=3.1.1
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

orafceFullV=3.15.0
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

mysqlfdwFullV=2.5.5
mysqlfdwShortV=
mysqlfdwBuildV=1

hivefdwFullV=4.0
hivefdwShortV=
hivefdwBuildV=1

mongofdwFullV=5.2.8
mongofdwShortV=
mongofdwBuildV=1

pgmpFullVersion=1.2.2
pgmpShortVersion=
pgmpBuildV=1

parquetFDWFullVersion=0.1.3
parquetFDWShortVersion=
parquetFDWBuildV=1

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

bulkloadFullV=3.1.17
bulkloadShortV=
bulkloadBuildV=1

spockFullV=3.1.1
spockShortV=
spockBuildV=1

pgLogicalFullV=2.3.3
pgLogicalShortV=
pgLogicalBuildV=1

repackFullV=1.4.6
repackShortV=
repackBuildV=1

partmanFullV=4.5.0
partmanShortV=
partmanBuildV=1

hintplanFullV=1.3.4
hintplanShortV=
hintplanBuildV=1

timescaledbFullV=2.1.1
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
