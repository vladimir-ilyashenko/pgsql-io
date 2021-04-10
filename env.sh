
bundle=pgsql
api=io
hubV=6.42

P13=13.2-3
P12=12.6-3
P11=11.11-3
P10=10.16-1
P96=9.6.21-1
P95=9.5.26-1

esfdwV=0.10.2
odbcV=13.00-1
backrestV=2.33-1
bouncerV=1.15.0-1
pgtopV=3.7.0-1
proctabV=0.0.8.1-1
citusV=10.0.3-1
multicornV=1.4.0-1
orafceV=3.15.0-1
fdV=1.1.0-1
httpV=1.3.1-1
anonV=0.8.1-1
ddlxV=0.17-1
hypoV=1.2.0-1
timescaleV=2.1.1-1
logicalV=2.3.3-1
profV=4.1-1
bulkloadV=3.1.17-1
partmanV=4.5.0-1
repackV=1.4.6-1

zooV=3.7.0
kfkV=2.7.0
dbzV=1.5.0

adminV=5.1
omniV=2.17.0

audit13V=1.5.0-1
postgisV=3.1.1-1

tsqlV=3.0-1
pljavaV=1.6.2-1
debuggerV=2.0-1
agentV=4.0-1
cronV=1.3.1-1

mysqlfdwV=2.5.5-1
mongofdwV=5.2.8-1
oraclefdwV=2.3.0-1
tdsfdwV=2.0.2-1
cstarfdwV=3.1.5-1
hivefdwV=4.0-1
hadoopV=2.10.0
badgerV=11.4
ora2pgV=21.0

HUB="$PWD"
SRC="$HUB/src"
zipOut="off"
isENABLED=false

pg="postgres"

OS=`uname -s`

if [[ $OS == "Linux" ]]; then
  if [ `arch` == "aarch64" ]; then
    OS=arm
    outDir=a64
  else
    OS=amd;
    outDir=l64
  fi
elif [[ $OS == "Darwin" ]]; then
  outDir=m64
  if [ `arch` == "aarch64" ]; then
    OS=arm
  else
    OS=amd;
  fi
else
  echo "ERROR: '$OS' is not supported"
  return
fi

plat=$OS
