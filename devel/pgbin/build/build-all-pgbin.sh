#!/bin/bash
#

pgSrc=$SRC/postgresql
binBld=/opt/pgbin-build/builds
source ./versions.sh


function runPgBin {
  ##echo "#"
  pOutDir=$1
  ##echo "# outDir = $pOutDir"
  pPgSrc=$2
  ##echo "# pPgSrc = $pPgSrc"
  pBldV=$3
  ##echo "#   BldV = $pBldV"

  bncrSrc=$SRC/pgbouncer-$bouncerV.tar.gz
  odbcSrc=$SRC/psqlodbc-$odbcV.tar.gz
  bkrstSrc=$SRC/backrest-$backrestV.tar.gz
  agentSrc=$SRC/agent-$agentV.tar.gz
 
  cmd="./build-pgbin.sh -a $pOutDir -t $pPgSrc -n $pBldV "

  ##if [ `uname` == "Linux" ]; then
  ##  cmd="$cmd -b $bncrSrc"
  ##  #cmd="$cmd -k $bkrstSrc"
  ##  if [ ! `arch` == "aarch64" ]; then
  ##    cmd="$cmd -g $agentSrc"
  ##  fi
  ##  #cmd="$cmd -o $odbcSrc"
  ##fi

  cmd="$cmd $optional"
  $cmd
  if [[ $? -ne 0 ]]; then
    echo "Build Failed"
    exit 1	
  fi

  return
}

########################################################################
##                     MAINLINE                                       ##
########################################################################

## validate input parm
majorV="$1"
optional="$2"

if [ "$majorV" == "11" ]; then
  pgV=$pg11V
  pgBuildV=$pg11BuildV
elif [ "$majorV" == "12" ]; then
  pgV=$pg12V
  pgBuildV=$pg12BuildV
elif [ "$majorV" == "13" ]; then
  pgV=$pg13V
  pgBuildV=$pg13BuildV
elif [ "$majorV" == "14" ]; then
  pgV=$pg14V
  pgBuildV=$pg14BuildV
fi

if [ "$majorV" == "all" ]; then
  runPgBin "$binBld" "$pgSrc-$pg11V.tar.gz" "$pg11BuildV"
  runPgBin "$binBld" "$pgSrc-$pg12V.tar.gz" "$pg12BuildV"
  runPgBin "$binBld" "$pgSrc-$pg13V.tar.gz" "$pg13BuildV"
  runPgBin "$binBld" "$pgSrc-$pg14V.tar.gz" "$pg14BuildV"
else
  runPgBin "$binBld" "$pgSrc-$pgV.tar.gz" "$pgBuildV"
fi

exit 0
