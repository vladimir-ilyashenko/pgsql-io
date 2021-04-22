# copy-to-s3

if [ ! "$1" == "prod" ]; then
  echo "invalid 1st parm"
  exit 1
fi

if [ $# -ne 2 ]; then
  echo "ERROR: missing pOutDir parm"
  exit 1
fi

outDir=$HIST/$2
echo $outDir

if [ ! -d $outDir ]; then
  echo "ERROR: missing $outDir"
  exit 1
fi

sleep 2
cd $outDir
ls
sleep 2

flags="--acl public-read --storage-class STANDARD --recursive"
cmd="aws --region $REGION s3 cp . $BUCKET/REPO $flags"
echo $cmd
sleep 3

$cmd
rc=$?
echo "rc=($rc)"
exit $rc

