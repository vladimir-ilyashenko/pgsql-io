
if [ "$IN" == "" ]; then
  echo ERROR: Invalid Environment
  exit 1
fi

cd $IN
cp $IO/devel/util/in/pull-s3.sh .
./pull-s3.sh
chmod 755 *.sh
