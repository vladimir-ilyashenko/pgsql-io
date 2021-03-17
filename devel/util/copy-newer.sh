oldOutFile=$1
newOutDir=$2

find out -type f -newer out/$oldOutFile -exec cp -p {} $HIST/$newOutDir/. \;

rm -f $HIST/$newOutDir/pgsql-9*
rm -f $HIST/$newOutDir/pgsql-1*
