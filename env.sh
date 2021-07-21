
bundle=pgsql
api=io
hubV=6.52

P14=14beta2-1
P13=13.3-2
P12=12.7-2
P11=11.12-2
P10=10.17-1
P96=9.6.22-1

k8sV=1.21

w2jV=2.3-1
esfdwV=0.11.1
odbcV=13.01-1
pgtopV=3.7.0-1
proctabV=0.0.8.1-1
citusV=10.0.3-1
multicornV=1.4.1-1
hivefdwV=4.0-1

oraclefdwV=2.3.0-1
inclV=21.1
orafceV=3.15.1-1
ora2pgV=22.1

fdV=1.1.0-1
anonV=0.9.0-1
ddlxV=0.17-1
hypoV=1.3.1-1
timescaleV=2.3.1-1
logicalV=2.3.4-1
profV=4.1-1
bulkloadV=3.1.18-1
partmanV=4.5.1-1
repackV=1.4.6-1

waV=2.1-1
archiV=4.1.2-1
qstatV=2.0.3-1
statkV=2.2.0-1
waitsV=1.1.3-1

zooV=3.7.0
kfkV=2.7.1
dbzV=1.6.0
redisV=6.2
mariaV=10.6x
sqlsvrV=2019
mongoV=4.4
esV=7.x

adminV=5.4
omniV=2.17.0

audit13V=1.5.0-1
postgisV=3.1.3-1

tsqlV=3.0-1
pljavaV=1.6.2-1
debuggerV=2.0-1
agentV=4.0-1
cronV=1.3.1-1

pgredisV=2.0-1
mysqlfdwV=2.6.0-1
mongofdwV=5.2.9-1
tdsfdwV=2.0.2-1
cstarfdwV=3.1.5-1
badgerV=11.5
patroniV=2.1.0

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
