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

  bncrSrc=$SRC/bouncer-$bouncerFullV.tar.gz
  odbcSrc=$SRC/psqlodbc-$odbcV.tar.gz
  bkrstSrc=$SRC/backrest-$backrestFullV.tar.gz
  agentSrc=$SRC/agent-$agentV.tar.gz
 
  cmd="./build-pgbin.sh -a $pOutDir -t $pPgSrc -n $pBldV -b $bncrSrc -k $bkrstSrc"

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

if [ "$majorV" == "96" ]; then
  pgV=$pg96V
  pgBuildV=$pg96BuildV
elif [ "$majorV" == "10" ]; then
  pgV=$pg10V
  pgBuildV=$pg10BuildV
elif [ "$majorV" == "11" ]; then
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
  runPgBin "$binBld" "$pgSrc-$pg96V.tar.gz" "$pg96BuildV"
  runPgBin "$binBld" "$pgSrc-$pg10V.tar.gz" "$pg10BuildV"
  runPgBin "$binBld" "$pgSrc-$pg11V.tar.gz" "$pg11BuildV"
  runPgBin "$binBld" "$pgSrc-$pg12V.tar.gz" "$pg12BuildV"
  runPgBin "$binBld" "$pgSrc-$pg13V.tar.gz" "$pg13BuildV"
  runPgBin "$binBld" "$pgSrc-$pg14V.tar.gz" "$pg14BuildV"
else
  runPgBin "$binBld" "$pgSrc-$pgV.tar.gz" "$pgBuildV"
fi

exit 0
