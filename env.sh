
bundle=pgsql
api=io
hubV=6.35

P13=13.1-2
P12=12.5-2
P11=11.10-1
P10=10.15-1

dockerV=20.10.2
composeV=1.27.4
gccV=10.2.0

pgadminV=4

openstackV=2020.06-1
kvmV=8-1
cloudV=3.3.0
ansibleV=2.10.5
helmV=3.4.2
zookV=3.6.2
rabbitV=3.8.9
kafkaV=2.7.0
debezV=1.2.5
minikubeV=1.16.0

patroniV=2.0.1
haproxyV=1.8.23
etcdV=3.4.14

esfdwV=0.10.2
esV=7.10.1

odbcV=13.00-1
backrestV=2.31-1
bouncerV=1.15.0-1
pgtopV=3.7.0-1
proctabV=0.0.8.1-1
citusV=9.5.1-1

multicornV=1.4.0-1

orafceV=3.14.0-1
fdV=1.1.0-1
httpV=1.3.1-1
anonV=0.7.1-1
ddlxV=0.17-1
##omniV=3.03-1
hypoV=1.1.4-1
timescaleV=2.0.0-1
logicalV=2.3.3-1
##spockV=3.1.1-1
profV=4.1-1
bulkloadV=3.1.16-1
partmanV=4.4.1-1
repackV=1.4.6-1

audit13V=1.5.0-1
postgisV=3.1.0-1

tsqlV=3.0-1
pljavaV=1.6.2-1
debuggerV=2.0-1
agentV=4.0-1
cronV=1.3.0-1

mysqlfdwV=2.5.5-1
mariadbV=10.5-1

mongofdwV=5.2.8-1
mongodbV=4.4.3

oraclefdwV=2.3.0-1
oracle_xeV=18c-2

tdsfdwV=2.0.2-1
sqlsvrV=2019-1

cstarV=3.11-1
cstarfdwV=3.1.5-1

hivefdwV=4.0-1
prestosqlV=350
hadoopV=2.10.0
hiveV=3-1

badgerV=11.4
ora2pgV=20.0

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
