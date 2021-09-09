oldOutFile=$1
newOutDir=$2

if [ ! -f out/$oldOutFile ]; then
  echo "ERROR: OutFile (parm 1)"
  exit 1
fi

if [ ! -d $HIST/$newOutDir ]; then
  echo "ERROR: OutDir (parm 2)"
  exit 1
fi

find out -type f -newer out/$oldOutFile -exec cp -p {} $HIST/$newOutDir/. \;

rm -f $HIST/$newOutDir/pgsql-9*
rm -f $HIST/$newOutDir/pgsql-1*

ls $HIST/$newOutDir
