
if [ "$BLD" == "" ] || [ "$IN" == "" ]; then
  echo ERROR: Invalid Environment
  exit 1
fi

cd $BLD
cp -p $IO/devel/pgbin/build/*.sh .

cd $IN
cp $IO/devel/util/in/pull-s3.sh .
./pull-s3.sh prod
chmod 755 *.sh
